//
//  QuestionStore.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@class QuestionBase;
@class FMDatabase;
@class ReinforceQuestionStore;

@interface QuestionStore : NSObject

@property (strong, nonatomic) FMDatabase *dataBase;

- (NSString *)dbPath;

+ (QuestionStore *)exercisesStore;

+ (QuestionStore *)answerCacheStore;

- (QuestionBase *)currentQuestion;

- (QuestionBase *)nextQuestion;

- (QuestionBase *)prevQustion;

- (QuestionBase *)questionWithID:(NSInteger)questionID;

- (void)addcaCheQuestion:(QuestionBase *)question;

- (QuestionBase *)questionWithIDOnDB:(NSInteger)questionID;

@end
