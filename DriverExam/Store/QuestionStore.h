//
//  QuestionStore.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuestionBase;

@interface QuestionStore : NSObject

+ (QuestionStore *)exercisesStore;

+ (QuestionStore *)reinforceStore;

- (QuestionBase *)nextQuestion;

//- (void)saveQuestionResult:(QuestionBase *)qustion;

- (void)addQuestion:(QuestionBase *)question;

@end
