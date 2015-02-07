//
//  RegisterViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/6.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserEntity.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitButtonPress:(id)sender
{
    UserEntity *user = [self userInfo];
    
}

- (UserEntity *)userInfo
{
    return nil;
}

@end
