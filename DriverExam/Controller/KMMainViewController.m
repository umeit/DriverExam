//
//  KMMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "KMMainViewController.h"
#import "UIViewController+GViewController.h"

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface KMMainViewController ()

@end

@implementation KMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"1"]) {
        self.navigationItem.title = @"科目一";
    }
    else if ([[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"4"]) {
        self.navigationItem.title = @"科目四";
    }
    
    [self setBackButtonTitle:@"返回"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
