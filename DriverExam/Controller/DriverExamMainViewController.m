//
//  DriverExamMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "DriverExamMainViewController.h"
#import "KMMainViewController.h"
//#import "QuestionStore.h"
//#import "ReinforceQuestionStore.h"
//#import "ExamQuestionStore.h"

@interface DriverExamMainViewController ()

@end

@implementation DriverExamMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem.title = @"返回";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Action

- (IBAction)toKM1:(id)sender
{
    // 进入科目界面
    KMMainViewController *vc = [self kmMainVC];
    vc.kmType = KM1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toKM2:(id)sender
{
    // 进入科目界面
    KMMainViewController *vc = [self kmMainVC];
    vc.kmType = KM4;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private

- (KMMainViewController *)kmMainVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    KMMainViewController *vc = (KMMainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"KMMainViewController"];
    return vc;
}

@end
