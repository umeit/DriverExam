//
//  ExamFinishViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamFinishViewController.h"
#import "ExamQuestionStore.h"
#import "UIViewController+GViewController.h"

@interface ExamFinishViewController ()

@end

@implementation ExamFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self setBackButtonTitle:@"返回"];
    
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
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"KMMainViewController"];
//    [self.navigationController popToViewController:vc animated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)againButtonPress:(id)sender
{
    [[ExamQuestionStore examQuestionStore] examClear];
    
    // 回到考试主页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ExamStartViewController"];
    [self.navigationController popToViewController:vc animated:YES];
}

@end
