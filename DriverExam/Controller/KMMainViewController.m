//
//  KMMainViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "KMMainViewController.h"
#import "UIViewController+GViewController.h"
#import "GTMBase64.h"
#import "DEPayService.h"
#import "ExamQuestionStore.h"
#import "QuestionStore.h"

@interface KMMainViewController ()

@property (strong, nonatomic) DEPayService *payService;

@end

@implementation KMMainViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.payService = [[DEPayService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"1"]) {
        self.navigationItem.title = @"科目一";
        self.questionCountLabel.text = [@(LAST_INDEX_KM1) stringValue];
    }
    else if ([[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"4"]) {
        self.navigationItem.title = @"科目四";
        self.questionCountLabel.text = [@(LAST_INDEX_KM4) stringValue];
    }
    
    [self setBackButtonTitle:@"返回"];
    
    if (IsPayModel) {
        if (IS_Payed) {
            self.buyButton.hidden = YES;
        }
        else {
            self.buyButton.hidden = NO;
        }
    }
    else {
        self.buyButton.hidden = YES;
    }
    
    // 监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


#pragma mark - Action

/** 点击购买 */
- (IBAction)buyButtonPress:(id)sender
{
    [self showLodingView];
    
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo];
    } else {
        [self showCustomTextAlert:@"无法购买，您已禁止应用内付费."];
    }
}

/** 点击恢复购买 */
- (IBAction)rebuyButtonPress:(id)sender
{
    [self showLodingView];
    
//    if ([SKPaymentQueue canMakePayments]) {
//        [self getProductInfo];
//    } else {
//        [self showCustomTextAlert:@"无法购买，您已禁止应用内付费."];
//    }
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


/** 点击考试 */
- (IBAction)examButtonPress:(id)sender
{
    if (IsPayModel) {
        if (IS_Payed) {
            [self toExamVC];
        }
        else {
            if ([[ExamQuestionStore examQuestionStore] examCount] >= 3) {
                [self showCustomTextAlert:@"您已经试用3次，请购买完整版"];
            }
            else {
                [self toExamVC];
            }
        }
    }
    else {
        [self toExamVC];
    }
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased: //交易完成
                NSLog(@"交易完成");
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed: //交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored: //已经购买过该商品
                NSLog(@"已经购买过");
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"购买中");
                break;
            default:
                [self hideLodingView];
                break;
        }
        NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
    }
}

/** 恢复购买成功 */
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self hideLodingView];
    [USER_DEFAULTS setBool:YES forKey:@"IsPay"];
    self.buyButton.hidden = YES;
    self.rebuyButton.hidden = YES;
}

/** 恢复购买失败 */
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [self hideLodingView];
    [self showCustomTextAlert:@"恢复购买失败，请重试"];
}


#pragma mark - Private

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    if ([transaction.payment.productIdentifier length] > 0) {
        NSString *receipt = [self getReceipt];
        if (!receipt || [receipt isEqualToString:@""]) {
            NSLog(@"receipt is nil.");
            return;
        }
        
        // 验证购买凭证
        [self.payService checkReceipt:[self getReceipt] block:^(BOOL success){
            if (success) {
                
                // 第一次购买，记录用户的购买信息
                if (!transaction.originalTransaction) {
//                if (YES) {
                    [self.payService markPaymentInfo:transaction.transactionIdentifier
                                            userInfo:[self currentUser]
                                               block:^(BOOL success){
                                                   if (success) {
                                                       // 设置为已购买
                                                       [USER_DEFAULTS setBool:YES forKey:@"IsPay"];
                                                       self.buyButton.hidden = YES;
                                                       self.rebuyButton.hidden = YES;
                                                   }
                                                   else {
                                                       [self hideLodingView];
                                                       [self showCustomTextAlert:@"购买失败"];
                                                   }
                                                   [self hideLodingView];
                    }];
                }
                else {
                    [self hideLodingView];
                    // 设置为已购买
                    [USER_DEFAULTS setBool:YES forKey:@"IsPay"];
                    self.buyButton.hidden = YES;
                    self.rebuyButton.hidden = YES;
                }
                
            // 验证凭证失败
            } else {
                [self hideLodingView];
                [self showCustomTextAlert:@"购买失败"];
            }
        }];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (NSString *)getReceipt
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSError *error = nil;
    NSData *receiptData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    NSString *receipt = [GTMBase64 stringByEncodingData:receiptData];
    
    return receipt;
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [self hideLodingView];
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self showCustomTextAlert:@"购买失败，请重试（不会重复付费）。"];
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
//    [self hideLodingView];
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)getProductInfo
{
    NSSet * set = [NSSet setWithArray:@[@"all_function"]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

- (void)toExamVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *reinforceVC = [storyboard instantiateViewControllerWithIdentifier:@"ExamStartViewController"];
    [self.navigationController pushViewController:reinforceVC animated:YES];
}

- (UserEntity *)currentUser
{
    NSData *data = [USER_DEFAULTS objectForKey:CURRENT_USER];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
