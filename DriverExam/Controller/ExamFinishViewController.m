//
//  ExamFinishViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamFinishViewController.h"
#import "ExamQuestionStore.h"
#import "UIViewController+GViewController.h"
#import "ReviewViewController.h"
#import "MobClick.h"

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
    
    // 在这里判断
    if ([ExamQuestionStore examQuestionStore].lastScore < 90) {
        self.examResultImageView.image = [UIImage imageNamed:@"exam_failure"];
        self.textLabel.text = @"很遗憾";
        [self.textLabel setTintColor:[UIColor grayColor]];
    }
    else {
        [self.scoreLabel setTintColor:[UIColor redColor]];
        self.examResultImageView.image = [UIImage imageNamed:@"exam_pass"];
        self.textLabel.text = @"恭喜你";
        [self.textLabel setTintColor:[UIColor redColor]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ExamFinishView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ExamFinishView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)reviewFaultButtonPress:(id)sender
{
    ReviewViewController *reviewViewController = [[ReviewViewController alloc] initWithNibName:@"AnswerViewController" bundle:nil];
    reviewViewController.reviewType = REVIEW_TYPE_EXAM;
    [self.navigationController pushViewController:reviewViewController animated:YES];
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
