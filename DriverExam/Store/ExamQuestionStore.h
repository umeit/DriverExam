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

/** 完成考试，保存考试成绩，生成错题回顾 */
- (void)examFinish;

- (void)examClear;


/* 用于统计 */

- (NSInteger)examCount;

- (double)average;


/* 用于错题回顾 */

- (QuestionBase *)nextFaultQuestion;

- (QuestionBase *)prevFaultQuestion;

- (NSInteger)currentFaultQuestionIndex;

- (NSInteger)faultquestionCuont;

@end
