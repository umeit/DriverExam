//
//  ExercisesViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExercisesViewController.h"
#import "QuestionBase.h"
#import "ReinforceQuestionStore.h"

@interface ExercisesViewController ()

@end


@implementation ExercisesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Override

- (void)procNextQuestionButtonPress
{
    // 如当前题没做，记入强化练习
    if (!self.question.result) {
        [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    }
    
    [self showNextQuestion];
}

- (void)procPrevQuestionButtonPress
{
    [self showPrevQuestion];
}

- (void)showCurrentQuestion
{
    self.question = [[QuestionStore exercisesStore] currentQuestion];
    [self updateQuestionDisplay];
}

- (void)showNextQuestion
{
    // 获取下一个练习题
    self.question = [[QuestionStore exercisesStore] nextQuestion];
    // 更新题目显示
    [self updateQuestionDisplay];
}

- (void)showPrevQuestion
{
    self.question = [[QuestionStore exercisesStore] prevQustion];
    [self updateQuestionDisplay];
    if (self.question.qustoinID == 0) {
        self.prevButton.hidden = YES;
    }
}

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
    if (self.question.qustoinID == 1) {
        self.prevButton.hidden = YES;
    } else {
        self.prevButton.hidden = NO;
    }
    
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.question.qustoinID, [[QuestionStore exercisesStore] questionCuont]];
    
    // 显示最近做过的结果
    QuestionBase *question = [[QuestionStore answerCacheStore] questionWithID:self.question.qustoinID];
    if (question) {
        self.question = question;
        if (self.question.result == self.question.correctIndex) {
            [self showCorrectAnswer];
        }
        else {
            NSInteger correctButtonTag = self.question.result;
            self.selectedButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
            [self updateSelectedButtonFaultStatus];
            [self showCorrectAnswer];
        }
    }
}

/** 答对后的处理 */
- (void)answerDidCorrect
{
    // 记录本题的结果
    [[QuestionStore answerCacheStore] addcaCheQuestion:self.question];
    
    // 显示正确选项
    [self showCorrectAnswer];
    
    // 两秒后显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextQuestion];
    });
}

/** 答错后的处理 */
- (void)answerDidFault
{
    // 记录本题的结果
    [[QuestionStore answerCacheStore] addcaCheQuestion:self.question];
    
    // 将错题加入加强练习题库
    [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    
    // 显示错误/正确结果
    [self updateSelectedButtonFaultStatus];
    [self showCorrectAnswer];
}

@end
