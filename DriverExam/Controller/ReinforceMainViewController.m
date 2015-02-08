//
//  ReinforceMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/23.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceMainViewController.h"
#import "ReinforceQuestionStore.h"
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


- (IBAction)startReinforceButtonPress:(id)sender
{
    if (IsPayModel) {
        if (![USER_DEFAULTS boolForKey:@"IsPay"]) {
            [self showCustomTextAlert:@"请购买完整版"];
        } else {
            [self toReinforceVC];
        }
    }
    else {
        [self toReinforceVC];
    }
    
}

- (void)toReinforceVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *reinforceVC = [storyboard instantiateViewControllerWithIdentifier:@"ReinforceViewController"];
    [self.navigationController pushViewController:reinforceVC animated:YES];
}


@end
