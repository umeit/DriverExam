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

@property (strong, nonatomic) QuestionBase *question;

@property (strong, nonatomic) UIButton *selectedButton;

- (void)nextQuestion;

- (void)updateQuestionDisplay;

- (void)answerDidCorrect;

- (void)answerDidFault;

@end
