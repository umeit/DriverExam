//
//  ReinforceMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/23.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceMainViewController.h"
#import "ReinforceQuestionStore.h"
#import "ReinforcedViewController.h"
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
    
    self.faultQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] faultQuestionCount]) stringValue];
    self.missQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] missQuestionCount]) stringValue];
    self.reinforcedQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] reinforcedQuestionCount]) stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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


- (void)toReinforceVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *reinforceVC = [storyboard instantiateViewControllerWithIdentifier:@"ReinforceViewController"];
    [self.navigationController pushViewController:reinforceVC animated:YES];
}

- (void)toReinforcedVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *reinforceVC = [storyboard instantiateViewControllerWithIdentifier:@"ReinforceViewController"];
//    [self.navigationController pushViewController:reinforceVC animated:YES];
    // 转换思路搞，不用继承 ReviewViewController 了，直接用它
    ReinforcedViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
