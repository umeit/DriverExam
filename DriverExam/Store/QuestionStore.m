//
//  QuestionStore.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "QuestionStore.h"
#import "QuestionBase.h"

#import "FMDatabase.h"

#define CURRENT_QUESTION_INDEX @"CurrentQuestionIndex"

#define QUESTION_CONTENT @"name"

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface QuestionStore ()

@property (strong, nonatomic) FMDatabase *dataBase;

@end

static QuestionStore *exercisesStore = nil;

@implementation QuestionStore

+ (QuestionStore *)exercisesStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exercisesStore = [[self alloc] init];
    });
    
    return exercisesStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dataBase = [FMDatabase databaseWithPath:[self dbPath]];
        [USER_DEFAULTS registerDefaults:@{CURRENT_QUESTION_INDEX: @1}];
    }
    return self;
}

- (QuestionBase *)nextQuestion
{
    NSInteger currentQuestionIndex = [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX];
    currentQuestionIndex++;
    
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_library_general WHERE id = ?",
                           currentQuestionIndex];

    QuestionBase *question = nil;
    if ([result next]) {
        question = [[QuestionBase alloc] init];
        question.content = [result stringForColumn:QUESTION_CONTENT];
    }
    [USER_DEFAULTS setObject:@(currentQuestionIndex) forKey:CURRENT_QUESTION_INDEX];
    [self.dataBase close];
    return question;
}

- (NSString *)dbPath
{
    static NSString *dbPath;
    if (!dbPath) {
        dbPath = [[NSBundle mainBundle] pathForResource:@"km1" ofType:@"db"];
    }
    return dbPath;
}

@end
