//
//  ReinforceQuestionStore.h
//  DriverExam
//
//  Created by 沈 湛 on 15/1/26.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "QuestionStore.h"

@interface ReinforceQuestionStore : QuestionStore

+ (ReinforceQuestionStore *)reinforceStore;

- (void)addNeedReinforceQuestion:(QuestionBase *)question;

- (void)questionDidReinforced:(QuestionBase *)question;

- (NSInteger)faultQuestionCount;

- (NSInteger)missQuestionCount;

- (NSInteger)reinforcedQuestionCount;

- (QuestionBase *)nextQuestionWhenLastQuestionWsaCorrect;

@end