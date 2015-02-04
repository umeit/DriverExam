//
//  QuestionStore.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#define KM1DB @"km1"
#define KM4DB @"km4"

#define IS_KM1 [[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"1"]
#define IS_KM4 [[USER_DEFAULTS objectForKey:@"KM"] isEqualToString:@"4"]

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

+ (QuestionStore *)answerCacheStore;

- (QuestionBase *)currentQuestion;

- (QuestionBase *)nextQuestion;

- (QuestionBase *)prevQustion;

- (QuestionBase *)questionWithID:(NSInteger)questionID;

- (void)addcaCheQuestion:(QuestionBase *)question;

- (QuestionBase *)questionWithIDOnDB:(NSInteger)questionID;

- (NSInteger)questionCuont;

- (QuestionBase *)questionWithResult:(FMResultSet *)result;
@end
