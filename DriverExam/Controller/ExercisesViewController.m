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
    [self showNextQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Override

- (void)showNextQuestion
{
    NSLog(@"下一题");
    // 获取下一个练习题
    self.question = [[QuestionStore exercisesStore] nextQuestion];
    // 更新题目显示
    [self updateQuestionDisplay];
}

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
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

- (void)answerDidFault
{
    NSLog(@"错误！");
    // 将错题加入加强练习题库
    [[QuestionStore reinforceStore] addQuestion:self.question];
    [self updateSelectedButtonFaultStatus];
    [self showCorrectAnswer];
}


#pragma mark - Custom
- (IBAction)nextQuestionButtonPress:(id)sender
{
    NSLog(@"点击下一题");
    [self showNextQuestion];
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
