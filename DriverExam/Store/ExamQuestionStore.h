//
//  ExamQuestionStore.h
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "QuestionStore.h"

@interface ExamQuestionStore : QuestionStore

@property (nonatomic) NSInteger lastScore;

+ (ExamQuestionStore *)examQuestionStore;

- (void)initNewExam;

- (void)saveExamRusult:(QuestionBase *)question;

- (NSInteger)currentQuestionIndex;

//- (NSInteger)lastScore;

/** 完成考试，保存考试成绩 */
- (void)examFinish;

- (void)examClear;

- (NSInteger)examCount;

- (double)average;

- (QuestionBase *)nextFaultQuestion;

- (QuestionBase *)prevFaultQuestion;

@end
