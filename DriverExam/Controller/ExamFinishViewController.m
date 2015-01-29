//
//  ExamFinishViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamFinishViewController.h"

@interface ExamFinishViewController ()

@end

@implementation ExamFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButtonPress:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
