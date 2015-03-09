//
//  QuestionStore.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KM1DB @"km1.db"
#define KM4DB @"km4.db"

#define IS_KM1 [[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"1"]
#define IS_KM4 [[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"4"]

#define LAST_INDEX_KM1 1074
#define LAST_INDEX_KM4 899

@class QuestionBase;
@class FMDatabase;
@class ReinforceQuestionStore;
@class FMResultSet;

@interface QuestionStore : NSObject

@property (strong, nonatomic) FMDatabase *dataBase1;
@property (strong, nonatomic) FMDatabase *dataBase4;

- (FMDatabase *)dataBase;

- (NSString *)dbPath:(NSString *)name;

+ (QuestionStore *)exercisesStore;

- (QuestionBase *)currentQuestion;

- (QuestionBase *)nextQuestion;

- (QuestionBase *)prevQustion;

- (QuestionBase *)questionWithIDOnDB:(NSInteger)questionID;

- (NSInteger)questionCuont;

- (QuestionBase *)questionWithResult:(FMResultSet *)result;

- (BOOL)hasNextQuestion;

/** Cache */
+ (QuestionStore *)answerCacheStore;

- (QuestionBase *)questionWithIDOnCache:(NSInteger)questionID;

- (void)addCacheQuestion:(QuestionBase *)question;

- (void)clearCache;
@end
