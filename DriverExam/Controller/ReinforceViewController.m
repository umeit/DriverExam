//
//  ReinforceViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/26.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceViewController.h"
#import "ReinforceQuestionStore.h"
#import "QuestionBase.h"

@interface ReinforceViewController ()

@end
@implementation ReinforceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
                                 (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextQuestion];
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
}

@end
