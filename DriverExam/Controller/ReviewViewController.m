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
