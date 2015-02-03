//
//  ExamFinishViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamFinishViewController.h"
#import "ExamQuestionStore.h"

@interface ExamFinishViewController ()

@end

@implementation ExamFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.scoreLabel.text = [@([ExamQuestionStore examQuestionStore].lastScore) stringValue];
    self.examCountLabel.text = [@([[ExamQuestionStore examQuestionStore] examCount]) stringValue];
    self.averageLabel.text = [@([[ExamQuestionStore examQuestionStore] average]) stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)finishButtonPress:(id)sender
{
    [[ExamQuestionStore examQuestionStore] examClear];
    
    // 回到科目主页面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
