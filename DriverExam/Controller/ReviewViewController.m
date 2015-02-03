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
    
    self.navigationItem.title = @"错题回顾";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Override

- (void)showCurrentQuestion
{
    [[ExamQuestionStore examQuestionStore] resetReviewIndex];
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
    
    // 设置上一题、下一题按钮的显示
    if ([[ExamQuestionStore examQuestionStore] currentFaultQuestionIndex] == 1) {
        self.prevButton.hidden = YES;
    }
    else {
        self.prevButton.hidden = NO;
    }
    if ([[ExamQuestionStore examQuestionStore] currentFaultQuestionIndex] == [[ExamQuestionStore examQuestionStore] faultquestionCuont]) {
        self.nextButton.hidden = YES;
    }
    else {
        self.nextButton.hidden = NO;
    }
        
    
    // 显示答案
    [self showCorrectAnswer];
    // 显示选错的答案(如果有)
    NSInteger buttonTag = self.question.result;
    if (buttonTag) {
        self.selectedButton = (UIButton *)[self.view viewWithTag:buttonTag];
        [self updateSelectedButtonFaultStatus];
    }
}

- (void)procNextQuestionButtonPress
{
    self.question = [[ExamQuestionStore examQuestionStore] nextFaultQuestion];
    [self updateQuestionDisplay];
}

- (void)procPrevQuestionButtonPress
{
    self.question = [[ExamQuestionStore examQuestionStore] prevFaultQuestion];
    [self updateQuestionDisplay];
}

@end
