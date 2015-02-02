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

#pragma mark - Action

- (IBAction)selectAnswer:(UIButton *)sender
{
    self.selectedButton = sender;
    self.question.result = self.selectedButton.tag;  // 记录选择的答案
    // 答对
    if ([self isCorrectAnswer]) {
        [self answerDidCorrect];  // 子类实现
    // 答错
    } else {
        [self answerDidFault];  // 子类实现
    }
}

- (IBAction)nextQuestionButtonPress:(id)sender
{
    [self procNextQuestionButtonPress];
}

- (IBAction)prevQuestionButtonPress:(id)sender
{
    [self procPrevQuestionButtonPress];
}

/** 判断对错 */
- (BOOL)isCorrectAnswer
{
    return self.question.correctIndex == self.selectedButton.tag;
}

- (void)updateQuestionDisplay
{
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [self.question.order stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        self.questionImageView.hidden = NO;
        self.questionImageView.image = image;
    } else {
        self.questionImageView.hidden = YES;
    }

    self.questionContentLabel.text = self.question.content;
    NSLog(@"%d", self.question.qustoinID);
    
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
    
//    if (self.question.qustoinID == 1) {
//        self.prevButton.hidden = YES;
//    } else {
//        self.prevButton.hidden = NO;
//    }
    
//    if (self.questionImageView.hidden) {
//        CGRect frame = self.questionContentTextView.frame;
//        frame.origin.y = 72;
//        self.questionContentTextView.bounds = frame;
//    } else {
//        CGRect frame = self.questionContentTextView.frame;
//        frame.origin.y = 192;
//        self.questionContentTextView.bounds = frame;
//    }
}

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

- (void)procPrevQuestionButtonPress
{
}

- (void)procNextQuestionButtonPress
{
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

- (void)answerDidCorrect
{
}

- (void)answerDidFault
{
}

@end
