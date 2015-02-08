//
//  RegisterViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/6.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserEntity.h"
#import "UserService.h"
#import "UIViewController+GViewController.h"

@interface RegisterViewController ()

@property (strong, nonatomic) UserService *userService;

@end

@implementation RegisterViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userService = [[UserService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitButtonPress:(id)sender
{
    UserEntity *user = [self userInfo];
    [self.userService registerUser:user block:^(BOOL success, NSString *errorMgs) {
        if (success) {
            [self.userService saveUser:user];
        } else {
            [self showCustomTextAlert:@"登陆失败，请稍后再试."];
        }
    }];
}

- (UserEntity *)userInfo
{
    return nil;
}

@end
