//
//  ExamViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamViewController.h"
#import "ExamQuestionStore.h"

@interface ExamViewController ()
@property (nonatomic)  NSInteger secondsCountDown;
@property (strong, nonatomic) NSTimer *countDownTimer;
@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.examTimeLabel.text = @"45:00";
    
    self.secondsCountDown = 45 * 60; // 倒计时
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(timeFireMethod)
                                                         userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Override

- (void)showCurrentQuestion
{
    [[ExamQuestionStore examQuestionStore] initNewExam];
    self.question = [[ExamQuestionStore examQuestionStore] nextQuestion];
    [self updateQuestionDisplay];
}

- (void)answerDidCorrect
{
    [[ExamQuestionStore examQuestionStore] saveExamRusult:self.question];
    [self showNextQuestion];
}

- (void)answerDidFault
{
    [[ExamQuestionStore examQuestionStore] saveExamRusult:self.question];
    [self showNextQuestion];
}

- (void)showNextQuestion
{
    // 获取下一个练习题
    self.question = [[ExamQuestionStore examQuestionStore] nextQuestion];
    // 更新题目显示
    [self updateQuestionDisplay];
}

- (void)timeFireMethod {
    self.secondsCountDown--;
    NSInteger m = self.secondsCountDown / 60;
    self.examTimeLabel.text = [NSString stringWithFormat:@"%@:%@",
                               [@(m) stringValue], [@(self.secondsCountDown - (m * 60)) stringValue]];
    if(!self.secondsCountDown){
        [self.countDownTimer invalidate];
        
        // 交卷
    }
}
@end
