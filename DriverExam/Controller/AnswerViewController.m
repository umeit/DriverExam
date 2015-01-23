//
//  AnswerViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/15.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "AnswerViewController.h"

#import "QuestionBase.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showCurrentQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)selectAnswer:(UIButton *)sender
{
    self.selectedButton = sender;
    self.question.result = self.selectedButton.tag;
    // 答对
    if ([self isCorrectAnswer]) {
        [self answerDidCorrect];  // 子类实现
        
    // 答错
    } else {
        [self answerDidFault];  // 子类实现
    }
    
}

/** 判断对错 */
- (BOOL)isCorrectAnswer
{
    return self.question.correctIndex == self.selectedButton.tag;
}

- (void)showCurrentQuestion
{
}

- (void)showNextQuestion
{
}

- (void)showPrevQuestion
{
}

- (void)updateQuestionDisplay
{
    self.questionContentTextView.text = self.question.content;
    
    [self.answerButonA setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.answerButonB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.answerButonC setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.answerButonD setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    [self.answerButonA setTitle:[self.question.answerList objectAtIndex:0] forState:UIControlStateNormal];
    [self.answerButonB setTitle:[self.question.answerList objectAtIndex:1] forState:UIControlStateNormal];

    if ([self.question.answerList count] > 2) {
        self.answerButonC.hidden = NO;
        self.answerButonD.hidden = NO;
        [self.answerButonC setTitle:[self.question.answerList objectAtIndex:2] forState:UIControlStateNormal];
        [self.answerButonD setTitle:[self.question.answerList objectAtIndex:3] forState:UIControlStateNormal];
    } else {
        self.answerButonC.hidden = YES;
        self.answerButonD.hidden = YES;
    }
    
    if (self.question.qustoinID == 1) {
        self.prevButton.hidden = YES;
    } else {
        self.prevButton.hidden = NO;
    }
}

- (void)answerDidCorrect
{
}

- (void)answerDidFault
{
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
