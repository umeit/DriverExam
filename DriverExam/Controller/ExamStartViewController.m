//
//  ExamStartViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/5.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamStartViewController.h"
#import "UIViewController+GViewController.h"
#import "ExamViewController.h"

@interface ExamStartViewController ()

@end

@implementation ExamStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_KM1) {
        self.questionCountLabel.text = @"题数：100 题";
        self.questionScoreLabel.text = @"分值：每题 1 分";
        self.ExamTimeLabel.text = @"时间：45 分钟";
    } else if (IS_KM4) {
        self.questionCountLabel.text = @"题数：50 题";
        self.questionScoreLabel.text = @"分值：每题 2 分";
        self.ExamTimeLabel.text = @"时间：30 分钟";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startButtonPress:(id)sender
{
    ExamViewController *examViewController = [[ExamViewController alloc] initWithNibName:@"AnswerViewController" bundle:nil];
    [self.navigationController pushViewController:examViewController animated:YES];
}
@end
