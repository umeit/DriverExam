//
//  DriverExamMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "DriverExamMainViewController.h"
#import "UIViewController+GViewController.h"
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface DriverExamMainViewController ()

@end

@implementation DriverExamMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonTitle:@"返回"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Action

- (IBAction)toKM1:(id)sender
{
    [USER_DEFAULTS setObject:@"1" forKey:@"KM"];
    // 进入科目界面
    [self.navigationController pushViewController:[self kmMainVC] animated:YES];
}

- (IBAction)toKM2:(id)sender
{
    [USER_DEFAULTS setObject:@"4" forKey:@"KM"];
    // 进入科目界面
    [self.navigationController pushViewController:[self kmMainVC] animated:YES];
}


#pragma mark - Private

- (UIViewController *)kmMainVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"KMMainViewController"];
    return vc;
}

@end
