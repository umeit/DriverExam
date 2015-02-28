//
//  ReinforceMainViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/23.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceMainViewController.h"
#import "ReinforceQuestionStore.h"
#import "ReviewViewController.h"
#import "UIActionSheet+Blocks.h"
#import "UIViewController+GViewController.h"
#import "ReinforceViewController.h"

@interface ReinforceMainViewController ()

@end

@implementation ReinforceMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackButtonTitle:@"返回"];
    self.navigationItem.title = @"难题强化";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Action

/** 开始强化 */
- (IBAction)startReinforceButtonPress:(id)sender
{
    if (IsPayModel) {
        if (IS_Payed) {
            if ([[ReinforceQuestionStore reinforceStore] faultQuestionCount] == 0
                && [[ReinforceQuestionStore reinforceStore] missQuestionCount] == 0) {
                [self showCustomTextAlert:@"没有需要强化的试题"];
                return;
            }
            [self toReinforceVC];
        }
        else {
            [self showCustomTextAlert:@"请购买完整版"];
        }
    }
    else {
        [self toReinforceVC];
    }
    
}

/** 查看已强化 */
- (IBAction)watchReinforcedButtonPress:(id)sender
{
    if (IsPayModel) {
        if (IS_Payed) {
            if ([[ReinforceQuestionStore reinforceStore] reinforcedQuestionCount] == 0) {
                [self showCustomTextAlert:@"没有已经强化的试题"];
                return;
            }
            [self toReinforcedVC];
        }
        else {
            [self showCustomTextAlert:@"请购买完整版"];
        }
    }
    else {
        [self toReinforcedVC];
    }
}

/** 清楚 */
- (IBAction)clearButtonPress:(id)sender
{
    if (IsPayModel) {
        if (IS_Payed) {
            [self startActionSheet];
            
        }
        else {
            [self showCustomTextAlert:@"请购买完整版"];
        }
    }
    else {
        [self startActionSheet];
    }
}


#pragma mark - Private

- (void)startActionSheet
{
    [UIActionSheet showInView:self.view
                    withTitle:@"选择要清楚的内容"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"清除错题", @"清除未答", @"清除已强化"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         switch (buttonIndex) {
                             case 0:
                                 [[ReinforceQuestionStore reinforceStore] clearFault];
                                 [self updateCount];
                                 break;
                                 
                             case 1:
                                 [[ReinforceQuestionStore reinforceStore] clearMiss];
                                 [self updateCount];
                                 break;
                                 
                             case 2:
                                 [[ReinforceQuestionStore reinforceStore] clearReinforced];
                                 [self updateCount];
                                 break;
                                 
                             default:
                                 break;
                         }
                     }];
}

- (void)updateCount
{
    self.faultQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] faultQuestionCount]) stringValue];
    self.missQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] missQuestionCount]) stringValue];
    self.reinforcedQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] reinforcedQuestionCount]) stringValue];
}


- (void)toReinforceVC
{
    ReinforceViewController *reinforceViewController = [[ReinforceViewController alloc] initWithNibName:@"AnswerViewController" bundle:nil];
    [self.navigationController pushViewController:reinforceViewController animated:YES];
}

- (void)toReinforcedVC
{
    ReviewViewController *reviewViewController = [[ReviewViewController alloc] initWithNibName:@"AnswerViewController" bundle:nil];
    reviewViewController.reviewType = REVIEW_TYPE_REINFORCE;
    [self.navigationController pushViewController:reviewViewController animated:YES];
}


@end
