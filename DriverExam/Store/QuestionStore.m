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

#define QUESTION_ID @"id"
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

- (QuestionBase *)currentQuestion
{
    NSInteger currentQuestionIndex = [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX];
    
    QuestionBase *question = [self questionWithIDOnDB:currentQuestionIndex];
    
    return question;
}

- (QuestionBase *)nextQuestion
{
    NSInteger currentQuestionIndex = [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX];
    currentQuestionIndex++;
    
    QuestionBase *question = [self questionWithIDOnDB:currentQuestionIndex];
    
    [USER_DEFAULTS setObject:@(currentQuestionIndex) forKey:CURRENT_QUESTION_INDEX];
    
    return question;
}

- (QuestionBase *)prevQustion
{
    NSInteger currentQuestionIndex = [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX];
    currentQuestionIndex--;
    
    QuestionBase *question = [self questionWithIDOnDB:currentQuestionIndex];
    
    [USER_DEFAULTS setObject:@(currentQuestionIndex) forKey:CURRENT_QUESTION_INDEX];
    
    return question;
}

- (void)addcaCheQuestion:(QuestionBase *)question
                  withID:(NSInteger)questionID
{
    NSMutableDictionary *answerCache = (NSMutableDictionary *)[USER_DEFAULTS dictionaryForKey:ANSWER_CACHE];
    [answerCache setObject:question forKey:[@(questionID) stringValue]];
}

- (QuestionBase *)questionWithID:(NSInteger)questionID
{
    NSMutableDictionary *answerCache = (NSMutableDictionary *)[USER_DEFAULTS dictionaryForKey:ANSWER_CACHE];
    return [answerCache objectForKey:[@(questionID) stringValue]];
}

- (void)addNeedReinforceQuestion:(QuestionBase *)question
{
    if (![self.dataBase open]) {
        return;
    }
    
    [self.dataBase executeUpdate:@"INSERT INTO tbl_reinforce VALUES (?, ?)", question.qustoinID, question.result];
    
    [self.dataBase close];
}

#pragma mark - Private

- (QuestionBase *)questionWithIDOnDB:(NSInteger)questionID
{
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_library_general WHERE id = (?)",
                           @(questionID)];
    
    QuestionBase *question = nil;
    if ([result next]) {
        question = [[QuestionBase alloc] init];
        question.qustoinID = [result intForColumn:QUESTION_ID];
        question.content = [result stringForColumn:QUESTION_CONTENT];
        question.correctIndex = [result intForColumn:ANSWER_CORRECT];
        question.answerList = [[NSMutableArray alloc] init];
        if ([result stringForColumn:ANSWER_A]) {
            [question.answerList addObject:[result stringForColumn:ANSWER_A]];
        }
        if ([result stringForColumn:ANSWER_B]) {
            [question.answerList addObject:[result stringForColumn:ANSWER_B]];
        }
        if ([result stringForColumn:ANSWER_C]) {
            [question.answerList addObject:[result stringForColumn:ANSWER_C]];
        }
        if ([result stringForColumn:ANSWER_D]) {
            [question.answerList addObject:[result stringForColumn:ANSWER_D]];
        }
    }
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
