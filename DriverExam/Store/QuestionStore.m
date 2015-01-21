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
#define ANSWER_CACHE @"AnswerCache"

#define QUESTION_CONTENT @"name"
#define ANSWER_CORRECT @"answer"
#define ANSWER_A @"answer_a"
#define ANSWER_B @"answer_b"
#define ANSWER_C @"answer_c"
#define ANSWER_D @"answer_d"

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface QuestionStore ()
- (NSString *)dbPath;
@property (strong, nonatomic) FMDatabase *dataBase;
@end

static QuestionStore *exercisesStore = nil;
static QuestionStore *answerCacheStore = nil;

@implementation QuestionStore

+ (QuestionStore *)exercisesStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exercisesStore = [[self alloc] init];
    });
    
    return exercisesStore;
}

+ (QuestionStore *)answerCacheStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        answerCacheStore = [[self alloc] init];
    });
    
    return answerCacheStore;
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
        question.correctIndex = [result intForColumn:ANSWER_CORRECT];
        question.answerList = @[[result stringForColumn:ANSWER_A],
                                [result stringForColumn:ANSWER_B],
                                [result stringForColumn:ANSWER_C],
                                [result stringForColumn:ANSWER_D]];
    }
    
    [USER_DEFAULTS setObject:@(currentQuestionIndex) forKey:CURRENT_QUESTION_INDEX];
    [self.dataBase close];
    return question;
}

- (void)addcaCheQuestion:(QuestionBase *)question withID:(NSInteger)questionID
{
    NSMutableDictionary *answerCache = (NSMutableDictionary *)[USER_DEFAULTS dictionaryForKey:ANSWER_CACHE];
    [answerCache setObject:question forKey:[@(questionID) stringValue]];
}

- (QuestionBase *)questionWithID:(NSInteger)questionID
{
    NSMutableDictionary *answerCache = (NSMutableDictionary *)[USER_DEFAULTS dictionaryForKey:ANSWER_CACHE];
    return [answerCache objectForKey:[@(questionID) stringValue]];
}

#pragma mark - Private

- (NSString *)dbPath
{
    static NSString *dbPath;
    if (!dbPath) {
        dbPath = [[NSBundle mainBundle] pathForResource:@"km1" ofType:@"db"];
    }
    return dbPath;
}

@end
