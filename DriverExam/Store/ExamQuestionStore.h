//
//  ExamQuestionStore.h
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "QuestionStore.h"

@interface ExamQuestionStore : QuestionStore

+ (ExamQuestionStore *)examQuestionStore;

- (void)initNewExam;

- (void)saveExamRusult:(QuestionBase *)question;

@end
