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
    [self showNextQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)selectAnswer:(UIButton *)sender
{
    self.selectedButton = sender;
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
    return self.selectedButton.tag%2==0 ? YES : NO;
}

- (void)showNextQuestion
{
}

-(void)updateQuestionDisplay
{
    self.questionContentTextView.text = self.question.content;
    
    self.answerAButon.titleLabel.text = [self.question.answerList objectAtIndex:0];
    self.answerBButon.titleLabel.text = [self.question.answerList objectAtIndex:1];
    self.answerBButon.titleLabel.text = [self.question.answerList objectAtIndex:2];
    self.answerBButon.titleLabel.text = [self.question.answerList objectAtIndex:3];
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
