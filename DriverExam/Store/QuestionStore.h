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

+ (QuestionStore *)answerCacheStore;

- (QuestionBase *)currentQuestion;

- (QuestionBase *)nextQuestion;

- (QuestionBase *)prevQustion;

- (QuestionBase *)questionWithID:(NSInteger)questionID;

- (void)addcaCheQuestion:(QuestionBase *)question
                  withID:(NSInteger)questionID;

- (void)addNeedReinforceQuestion:(QuestionBase *)question;

@end
