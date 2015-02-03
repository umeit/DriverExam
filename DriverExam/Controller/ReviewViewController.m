//
//  ReviewViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/2.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReviewViewController.h"
#import "ExamQuestionStore.h"
#import "QuestionBase.h"

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

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
    // 显示页码
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d / %d",
                                     [[ExamQuestionStore examQuestionStore] currentFaultQuestionIndex],
                                     [[ExamQuestionStore examQuestionStore] faultquestionCuont]];
    // 显示答案
    [self showCorrectAnswer];
    // 显示选错的答案(如果有)
    NSInteger correctButtonTag = self.question.result;
    self.selectedButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
    [self updateSelectedButtonFaultStatus];
}

@end
