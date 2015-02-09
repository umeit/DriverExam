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
#import "ReinforceQuestionStore.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.reviewType == REVIEW_TYPE_EXAM) {
        self.navigationItem.title = @"错题回顾";
    } else {
        self.navigationItem.title = @"已强化";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Override

- (void)showCurrentQuestion
{
    if (self.reviewType == REVIEW_TYPE_EXAM) {
        [[ExamQuestionStore examQuestionStore] resetReviewIndex];
        self.question = [[ExamQuestionStore examQuestionStore] nextFaultQuestion];
    }
    else {
        self.question = [[ReinforceQuestionStore reinforceStore] currentReinforcedQuestion];
    }
    
    [self updateQuestionDisplay];
}

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
    [self setPageNumber];
    
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
    if (self.reviewType == REVIEW_TYPE_EXAM) {
        self.question = [[ExamQuestionStore examQuestionStore] nextFaultQuestion];
    }
    else {
        self.question = [[ReinforceQuestionStore reinforceStore] nextReinforcedQuestion];
    }
    
    [self updateQuestionDisplay];
}

- (void)procPrevQuestionButtonPress
{
    if (self.reviewType == REVIEW_TYPE_EXAM) {
        self.question = [[ExamQuestionStore examQuestionStore] prevFaultQuestion];
    }
    else {
        self.question = [[ReinforceQuestionStore reinforceStore] prevReinforcedQustion];
    }
    [self updateQuestionDisplay];
}


#pragma mark - Private

- (void)setPageNumber
{
    NSInteger index = 0;
    NSInteger count = 0;
    
    // 考试错题回顾
    if (self.reviewType == REVIEW_TYPE_EXAM) {
        index = [[ExamQuestionStore examQuestionStore] currentFaultQuestionIndex];
        count = [[ExamQuestionStore examQuestionStore] faultquestionCuont];
        // 显示页码
        self.questionNumberLabel.text = [NSString stringWithFormat:@"%d / %d", index, count];
        
        // 设置上一题、下一题按钮的显示
        if (index == 1) {
            self.prevButton.hidden = YES;
        }
        else {
            self.prevButton.hidden = NO;
        }
        if (index == count) {
            self.nextButton.hidden = YES;
        }
        else {
            self.nextButton.hidden = NO;
        }
    }
    // 查看已强化
    else {
        index = [[ReinforceQuestionStore reinforceStore] currenReinforcedQuestionIndex];
        count = [[ReinforceQuestionStore reinforceStore] reinforcedQuestionCount];
        // 显示页码
        self.questionNumberLabel.text = [NSString stringWithFormat:@"%d / %d", index, count];
        // 设置上一题、下一题按钮的显示
        if (index == 1) {
            self.prevButton.hidden = YES;
        }
        else {
            self.prevButton.hidden = NO;
        }
        if (index == count) {
            self.nextButton.hidden = YES;
        }
        else {
            self.nextButton.hidden = NO;
        }
    }
}

@end
