//
//  ReviewViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/2.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReviewViewController.h"
#import "ExamQuestionStore.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Override

- (void)showCurrentQuestion
{
    self.question = [[ExamQuestionStore examQuestionStore] nextFaultQuestion];
    [self updateQuestionDisplay];
}

@end
