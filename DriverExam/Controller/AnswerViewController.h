//
//  AnswerViewController.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/15.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionBase;

/** 
 * 答题控制器的基类
 * 用途：展示题目、选项，判断结果
 */
@interface AnswerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *questionContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *answerButonA;
@property (weak, nonatomic) IBOutlet UIButton *answerButonB;
@property (weak, nonatomic) IBOutlet UIButton *answerButonC;
@property (weak, nonatomic) IBOutlet UIButton *answerButonD;

@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) QuestionBase *question;

@property (strong, nonatomic) UIButton *selectedButton;

/** 需要子类实现 */

- (void)procNextQuestionButtonPress;

- (void)procPrevQuestionButtonPress;

- (void)showCurrentQuestion;

- (void)showNextQuestion;

- (void)showPrevQuestion;

- (void)updateQuestionDisplay;

- (void)answerDidCorrect;

- (void)answerDidFault;

@end
