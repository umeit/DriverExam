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
        // 取消选择
        if ([self.selectButtons containsObject:sender]) {
            [self.selectButtons removeObject:sender];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        // 选中
        else {
            [self.selectButtons addObject:sender];
            [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
        if ([self.question.results containsObject:@(sender.tag)]) {
            [self.question.results removeObject:@(sender.tag)];
        }
        else {
            [self.question.results addObject:@(sender.tag)];
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

/** 判断多选题结果 */
- (IBAction)okButtonPress:(id)sender
{
    if ([self.question.results isEqualToSet:self.question.correctIndexs]) {
        [self answerDidCorrect];  // 子类实现
    }
    [self answerDidFault];  // 子类实现
}

- (IBAction)nextQuestionButtonPress:(id)sender
{
    [self procNextQuestionButtonPress];
}

- (IBAction)prevQuestionButtonPress:(id)sender
{
    [self procPrevQuestionButtonPress];
}


#pragma mark - Custom

/** 判断对错 */
- (BOOL)isCorrectAnswer
{
    return self.question.correctIndex == self.selectedButton.tag;
}

- (void)updateQuestionDisplay
{   
    [self operationButtonEnabled:YES];
    
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
        self.questionImageView.image = nil;
        self.questionImageView.image = image;
    } else {
        self.questionImageView.hidden = YES;
    }

    self.questionContentLabel.text = self.question.content;
    
    [self.answerButonA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answerButonB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answerButonC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answerButonD setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
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
    
    self.aFalseImageView.hidden = YES;
    self.aTrueImageView.hidden = YES;
    self.bFalseImageView.hidden = YES;
    self.bTrueImageView.hidden = YES;
    self.cFalseImageView.hidden = YES;
    self.cTrueImageView.hidden = YES;
    self.dFalseImageView.hidden = YES;
    self.dTrueImageView.hidden = YES;
    
    self.selectButtons = [[NSMutableSet alloc] init];
}

- (void)updateSelectedButtonFaultStatus
{
    // 多选
    if (self.question.correctIndexs) {
        for (NSNumber *result in self.question.results) {
            if (![self.question.correctIndexs containsObject:result]) {
                UIButton *button = (UIButton *)[self.view viewWithTag:[result integerValue]];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self showFalseIcon:[result integerValue]];
            }
        }
    }
    // 单选、判断
    else {
        [self.selectedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self showFalseIcon:self.selectedButton.tag];
    }
}

- (void)showCorrectAnswer
{
    // 多选
    if (self.question.correctIndexs) {
        for (NSNumber *tag in self.question.correctIndexs) {
            UIButton *correctButton = (UIButton *)[self.view viewWithTag:[tag integerValue]];
            [correctButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            [self showTrueIcon:[tag integerValue]];
        }
    }
    // 单选、判断
    else {
        NSInteger correctButtonTag = self.question.correctIndex;
        if (correctButtonTag) {
            UIButton *correctButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
            [correctButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            [self showTrueIcon:correctButtonTag];
        }
    }
}

- (void)operationButtonEnabled:(BOOL)b
{
    self.answerButonA.userInteractionEnabled = b;
    self.answerButonB.userInteractionEnabled = b;
    self.answerButonC.userInteractionEnabled = b;
    self.answerButonD.userInteractionEnabled = b;
    
    self.okButton.userInteractionEnabled = b;
}

#pragma mark -

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


#pragma mark - Private

- (void)showTrueIcon:(NSInteger)tag
{
    switch (tag) {
        case 1:
            self.aTrueImageView.hidden = NO;
            break;
        case 2:
            self.bTrueImageView.hidden = NO;
            break;
        case 3:
            self.cTrueImageView.hidden = NO;
            break;
        case 4:
            self.dTrueImageView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)showFalseIcon:(NSInteger)tag
{
    switch (tag) {
        case 1:
            self.aFalseImageView.hidden = NO;
            break;
        case 2:
            self.bFalseImageView.hidden = NO;
            break;
        case 3:
            self.cFalseImageView.hidden = NO;
            break;
        case 4:
            self.dFalseImageView.hidden = NO;
            break;
        default:
            break;
    }
}

@end
