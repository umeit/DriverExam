//
//  KMMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "KMMainViewController.h"
#import "UIViewController+GViewController.h"
#import "GTMBase64.h"

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface KMMainViewController ()

@end

@implementation KMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"1"]) {
        self.navigationItem.title = @"科目一";
    }
    else if ([[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"4"]) {
        self.navigationItem.title = @"科目四";
    }
    
    [self setBackButtonTitle:@"返回"];
    
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

- (IBAction)buyButtonPress:(id)sender
{
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
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

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


#pragma mark - Private

- (void)getProductInfo
{
    NSSet * set = [NSSet setWithArray:@[@"all_function"]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

@end
