//
//  ReinforcedViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/8.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforcedViewController.h"
#import "ReinforceQuestionStore.h"
#import "ReinforceQuestion.h"

@interface ReinforcedViewController ()

@end

@implementation ReinforcedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"已强化";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showCurrentQuestion
{
    self.question = [[ReinforceQuestionStore reinforceStore] currentReinforcedQuestion];
    [self updateQuestionDisplay];
}

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
    // 显示答案
    [self showCorrectAnswer];
}

@end
