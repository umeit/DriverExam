//
//  KMMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "KMMainViewController.h"

@interface KMMainViewController ()

@end

@implementation KMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.kmType == KM1) {
        self.navigationItem.title = @"科目一";
    }
    else if (self.kmType == KM4) {
        self.navigationItem.title = @"科目四";
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
