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


#pragma mark - Private

- (void)updateCount
{
    self.faultQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] faultQuestionCount]) stringValue];
    self.missQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] missQuestionCount]) stringValue];
    self.reinforcedQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] reinforcedQuestionCount]) stringValue];
}


- (void)toReinforceVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *reinforceVC = [storyboard instantiateViewControllerWithIdentifier:@"ReinforceViewController"];
    [self.navigationController pushViewController:reinforceVC animated:YES];
}

- (void)toReinforcedVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ReviewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    vc.reviewType = REVIEW_TYPE_REINFORCE;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
