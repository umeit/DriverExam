//
//  DriverExamMainViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "DriverExamMainViewController.h"
#import "UIViewController+GViewController.h"
#import "RegisterViewController.h"
#import "MobClick.h"

@interface DriverExamMainViewController ()

@end

@implementation DriverExamMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonTitle:@"返回"];
    
    if ([USER_DEFAULTS dataForKey:CURRENT_USER]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (![USER_DEFAULTS dataForKey:CURRENT_USER]) {
//    
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        UIViewController *registerVC = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewControllerNav"];
//        [self.navigationController presentViewController:registerVC animated:YES completion:nil];
//    }
    if ([USER_DEFAULTS dataForKey:CURRENT_USER]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    [MobClick beginLogPageView:@"DriverExamMainView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"DriverExamMainView"];
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

//- (IBAction)adButtonPress:(id)sender
//{
//    
//}

#pragma mark - Private

- (UIViewController *)kmMainVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"KMMainViewController"];
    return vc;
}

@end
