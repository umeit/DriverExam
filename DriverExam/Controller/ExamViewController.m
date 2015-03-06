//
//  ExamViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamViewController.h"
#import "ExamQuestionStore.h"
#import "QuestionBase.h"
#import "UIViewController+GViewController.h"
#import "MobClick.h"

@interface ExamViewController ()
@property (nonatomic)  NSInteger secondsCountDown;
@property (strong, nonatomic) NSTimer *countDownTimer;
@end

@implementation ExamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.examTimeLabel.hidden = NO;
    
    if (IS_KM1) {
        self.navigationItem.title = @"科目一考试";
        self.examTimeLabel.text = @"45:00";
        self.secondsCountDown = 45 * 60; // 倒计时
        
    } else if (IS_KM4) {
        self.navigationItem.title = @"科目四考试";
        self.examTimeLabel.text = @"30:00";
        self.secondsCountDown = 30 * 60; // 倒计时
    }

    // 考试定时器
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(timeFireMethod)
                                                         userInfo:nil repeats:YES];
    // 交卷按钮
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithTitle:@"交卷"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(submitButtonPress:)];
    self.navigationItem.rightBarButtonItem = submitItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ExamView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ExamView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Action

- (IBAction)submitButtonPress:(id)sender
{
    [self showCustomTextAlert:@"确定交卷吗？" withOKButtonPressed:^{
        [self.countDownTimer invalidate];
        [self examFinish];
    }];
}


#pragma mark - Override

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld / %ld",
                                     (long)[[ExamQuestionStore examQuestionStore] currentQuestionIndex],
                                     (long)[[ExamQuestionStore examQuestionStore] questionCuont]];
    
    // 设置上一题、下一题按钮的显示
    if ([[ExamQuestionStore examQuestionStore] currentQuestionIndex] == 1) {
        self.prevButton.hidden = YES;
    }
    else {
        self.prevButton.hidden = NO;
    }
    if ([[ExamQuestionStore examQuestionStore] currentQuestionIndex] == [[ExamQuestionStore examQuestionStore] questionCuont]) {
        self.nextButton.hidden = YES;
    }
    else {
        self.nextButton.hidden = NO;
    }
    
    if (self.question.result) {
        UIButton *selectedButton = (UIButton *)[self.view viewWithTag:self.question.result];
        [selectedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

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

- (void)procNextQuestionButtonPress
{
    self.question = [[ExamQuestionStore examQuestionStore] nextQuestion];
    [self updateQuestionDisplay];
}

- (void)procPrevQuestionButtonPress
{
    self.question = [[ExamQuestionStore examQuestionStore] prevQustion];
    [self updateQuestionDisplay];
}


#pragma mark - Custom

- (void)examFinish
{
    [[ExamQuestionStore examQuestionStore] examFinish];
    
    // 进入考试结果界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *examFinishVC = [storyboard instantiateViewControllerWithIdentifier:@"ExamFinishViewController"];
    [self.navigationController pushViewController:examFinishVC animated:YES];
}

- (void)timeFireMethod
{
    self.secondsCountDown--;
    NSInteger m = self.secondsCountDown / 60;
    self.examTimeLabel.text = [NSString stringWithFormat:@"%@:%@",
                               [@(m) stringValue], [@(self.secondsCountDown - (m * 60)) stringValue]];
    if(!self.secondsCountDown){
        [self.countDownTimer invalidate];
        
        [self showCustomTextAlert:@"考试时间到，考试结束。" withBlock:^{
            [self examFinish];
        }];
    }
}
@end
