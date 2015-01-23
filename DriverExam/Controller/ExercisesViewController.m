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
                                 (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextQuestion];
    });
}

/** 答错后的处理 */
- (void)answerDidFault
{
    // 记录本题的结果
    [[QuestionStore answerCacheStore] addcaCheQuestion:self.question];
    
    // 将错题加入加强练习题库
    [[QuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    
    // 显示错误/正确结果
    [self updateSelectedButtonFaultStatus];
    [self showCorrectAnswer];
}


#pragma mark - Action

/** 点击下一题按钮 */
- (IBAction)nextQuestionButtonPress:(id)sender
{
    // 如当前题没做，记入强化练习
    if (!self.question.result) {
        [[QuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    }
    
    [self showNextQuestion];
}

- (IBAction)prevQuestionButtonPress:(id)sender
{
    [self showPrevQuestion];
}


#pragma mark - Custom

/** 将当前选中的按钮改为‘错误’状态 */
- (void)updateSelectedButtonFaultStatus
{
    [self.selectedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)showCorrectAnswer
{
    NSInteger correctButtonTag = self.question.correctIndex;
    UIButton *correctButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
    [correctButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
