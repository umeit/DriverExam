//
//  ExercisesViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExercisesViewController.h"
#import "QuestionStore.h"

@interface ExercisesViewController ()
- (void)updateButtonColorWithCorrectColor;
@end


@implementation ExercisesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self nextQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Override

- (void)nextQuestion
{
    NSLog(@"下一题");
    // 获取下一个练习题
    self.question = [[QuestionStore exercisesStore] nextQuestion];
    // 更新题目显示
    [self updateQuestionDisplay];
}

- (void)answerDidCorrect
{
    NSLog(@"正确！");
//    [[QuestionStore exercisesStore] saveQuestionResult:self.question];
    [self updateButtonColorWithCorrectColor];
    [self nextQuestion];
}

- (void)answerDidFault
{
    NSLog(@"错误！");
    // 将错题加入加强练习题库
    [[QuestionStore reinforceStore] addQuestion:self.question];
    [self showCorrectAnswer];
}


#pragma mark - Custom
- (IBAction)nextQuestionButtonPress:(id)sender
{
    NSLog(@"点击下一题");
}

- (void)updateButtonColorWithCorrectColor
{
    NSLog(@"改变正确按钮颜色");
}

- (void)showCorrectAnswer
{
    NSLog(@"显示正确答案");
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
