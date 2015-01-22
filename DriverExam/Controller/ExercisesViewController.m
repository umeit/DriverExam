//
//  ExercisesViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExercisesViewController.h"
#import "QuestionStore.h"
#import "QuestionBase.h"

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
}

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
    // 显示最近做过的结果
    QuestionBase *question = [[QuestionStore answerCacheStore] questionWithID:self.question.qustoinID];
    if (question) {
        if (question.result == question.correctIndex) {
            [self showCorrectAnswer];
        }
        else {
            NSInteger correctButtonTag = self.question.correctIndex;
            self.selectedButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
            [self updateSelectedButtonFaultStatus];
            [self showCorrectAnswer];
        }
    }
}

/** 答对后的处理 */
- (void)answerDidCorrect
{
    NSLog(@"正确！");
    // 显示正确选项
    [self showCorrectAnswer];
    
    // 记录本题的结果
    [[QuestionStore answerCacheStore] addcaCheQuestion:self.question withID:self.question.qustoinID];
    // 两秒后显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextQuestion];
    });
}

/** 答错后的处理 */
- (void)answerDidFault
{
    NSLog(@"错误！");
    // 将错题加入加强练习题库
    [[QuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    [self updateSelectedButtonFaultStatus];
    [self showCorrectAnswer];
}


#pragma mark - Action

/** 点击下一题按钮 */
- (IBAction)nextQuestionButtonPress:(id)sender
{
    NSLog(@"点击下一题");
    // 判断当前题有没有做
    [self showNextQuestion];
}

- (IBAction)prevQuestionButtonPress:(id)sender
{
    NSLog(@"点击上一题");
    [self showPrevQuestion];
}


/** 将当前选中的按钮改为‘错误’状态 */
- (void)updateSelectedButtonFaultStatus
{
    self.selectedButton.titleLabel.textColor = [UIColor grayColor];
}

- (void)showCorrectAnswer
{
    NSInteger correctButtonTag = self.question.correctIndex;
    UIButton *correctButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
    correctButton.titleLabel.textColor = [UIColor redColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
