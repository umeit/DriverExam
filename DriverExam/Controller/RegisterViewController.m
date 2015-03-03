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

- (void)viewWillAppear:(BOOL)animated
{
    self.schoolNameLabel.text = [USER_DEFAULTS stringForKey:@"schoolName"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Action

- (IBAction)submitButtonPress:(id)sender
{
    UserEntity *user = [self userInfo];
    if ([self checkUser:user]) {
        [self showLodingView];
        [self.userService registerUser:user block:^(NSInteger uID, NSString *errorMgs) {
            [self hideLodingView];
            if (uID) {
                // 登录成功，获取ID
                user.userID = uID;
                [self.userService saveUser:user];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self showCustomTextAlert:@"登陆失败，请稍后再试."];
            }
        }];
    }
    else {
        [self showCustomTextAlert:@"请填写完整信息"];
    }
}


#pragma mark - Private

- (BOOL)checkUser:(UserEntity *)user
{
    if (user.name == nil || [user.name isEqualToString:@""]
        || user.age == 0
        || [user.mobile isEqualToString:@""] || user.mobile.length != 11
        || user.sex == -1
        || user.school == 0) {
        return NO;
    }
    return YES;
}

- (UserEntity *)userInfo
{
    UserEntity *user = [[UserEntity alloc] init];
    user.name = self.nameField.text;
    user.age = [self.ageField.text integerValue];
    user.sex = self.sexSegmentControl.selectedSegmentIndex;
    user.mobile = self.mobileField.text;
    user.school = [USER_DEFAULTS integerForKey:@"schoolID"];
    
    return user;
}

@end
