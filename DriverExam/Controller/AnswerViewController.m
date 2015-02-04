//
//  AnswerViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/15.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "AnswerViewController.h"
#import "QuestionStore.h"
#import "QuestionBase.h"
#import "YLGIFImage.h"

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
    // 多选题
    if (self.question.correctIndexs) {
        // 选中
        if ([self.selectButtons containsObject:sender]) {
            [self.selectButtons removeObject:sender];
            [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        // 取消选择
        else {
            [self.selectButtons addObject:sender];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    // 单选题/判断题
    else {
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
}

- (IBAction)okButtonPress:(id)sender
{
    if (self.selectButtons.count != self.question.correctIndexs.count) {
        // 答错
        [self answerDidFault];  // 子类实现
        return;
    }
    for (UIButton *button in self.selectButtons) {
        if (![self.question.results containsObject:@(button.tag)]) {
            // 答错
            [self answerDidFault];  // 子类实现
            return;
        }
    }
    // 答对
    [self answerDidCorrect];  // 子类实现
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
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",
                           [self.question.order stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (!image) {
        imageName = [NSString stringWithFormat:@"%@.gif",
                               [self.question.order stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        image = [YLGIFImage imageNamed:imageName];
    }
    
    if (image) {
        self.questionImageView.hidden = NO;
        self.questionImageView.image = image;
    } else {
        self.questionImageView.hidden = YES;
    }

//    self.questionContentLabel.adjustsFontSizeToFitWidth = YES;
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
    
    if (self.question.correctIndexs) {
        self.okButton.hidden = NO;
    } else {
        self.okButton.hidden = YES;
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
    // 多选
    if (self.question.correctIndexs) {
        for (NSNumber *tag in self.question.correctIndexs) {
            UIButton *correctButton = (UIButton *)[self.view viewWithTag:[tag integerValue]];
            [correctButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
    // 单选、判断
    else {
        NSInteger correctButtonTag = self.question.correctIndex;
        UIButton *correctButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
        [correctButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
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
