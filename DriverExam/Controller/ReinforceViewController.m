//
//  ReinforceViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/26.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceViewController.h"
#import "ReinforceQuestionStore.h"
#import "QuestionBase.h"
#import "MobClick.h"

@interface ReinforceViewController ()

@end

@implementation ReinforceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"强化练习";
    
    // 隐藏上一题下一题按钮
    self.nextButton.hidden = YES;
    self.prevButton.hidden = YES;
    
    self.questionNumberLabel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ReinforceView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ReinforceView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Override

- (void)showCurrentQuestion
{
    self.question = [[ReinforceQuestionStore reinforceStore] currentQuestion];
    [self updateQuestionDisplay];
}

/** 答对后的处理 */
- (void)answerDidCorrect
{
    // 记录本题的结果
//    [[QuestionStore answerCacheStore] addcaCheQuestion:self.question];
    
    // 显示正确选项
    [self showCorrectAnswer];
    
    // 标记为已强化
    [[ReinforceQuestionStore reinforceStore] questionDidReinforced:self.question];
    
    // 自动显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextQuestionWhenLastQuestionWsaCorrect];
    });
}

/** 答错后的处理 */
- (void)answerDidFault
{
    // 记录本题的结果
//    [[QuestionStore answerCacheStore] addcaCheQuestion:self.question];
    
    // 将错题加入加强练习题库
//    [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    
    [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    
    // 显示错误/正确结果
    [self updateSelectedButtonFaultStatus];
    [self showCorrectAnswer];
    
    // 两秒后显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextQuestion];
    });
}

- (void)showNextQuestionWhenLastQuestionWsaCorrect
{
    self.question = [[ReinforceQuestionStore reinforceStore] nextQuestionWhenLastQuestionWsaCorrect];
    [self updateQuestionDisplay];
}


#pragma mark - Override

- (void)showNextQuestion
{
    QuestionBase *question = [[ReinforceQuestionStore reinforceStore] nextQuestion];
    if (question) {
        self.question = question;
        [self updateQuestionDisplay];
    }
}

@end
