//
//  QuestionStore.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "QuestionStore.h"
#import "QuestionBase.h"
#import "ReinforceQuestion.h"
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

#define REINFORCE_ID @"id"
#define QUESTION_ID_IN_REINFORCE @"question_id"
#define RESULT @"result"
#define STATUS @"status"

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface QuestionStore ()
- (NSString *)dbPath;
@property (strong, nonatomic) FMDatabase *dataBase;
@end

static QuestionStore *exercisesStore = nil;
static QuestionStore *answerCacheStore = nil;
static QuestionStore *reinforceStore = nil;

@implementation QuestionStore

+ (QuestionStore *)exercisesStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exercisesStore = [[self alloc] init];
    });
    
    return exercisesStore;
}

+ (QuestionStore *)reinforceStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reinforceStore = [[self alloc] init];
    });
    
    return reinforceStore;
}

+ (QuestionStore *)answerCacheStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        answerCacheStore = [[self alloc] init];
        [USER_DEFAULTS registerDefaults:@{ANSWER_CACHE: @{}}];
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
{
    NSMutableDictionary *dic = [self answerCacheDic];
    [dic setObject:[NSKeyedArchiver archivedDataWithRootObject:question] forKey:[@(question.qustoinID) stringValue]];
    [USER_DEFAULTS setObject:dic forKey:ANSWER_CACHE];
}

- (QuestionBase *)questionWithID:(NSInteger)questionID
{
    NSData *data = [[self answerCacheDic] objectForKey:[@(questionID) stringValue]];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)addNeedReinforceQuestion:(QuestionBase *)question
{
    ReinforceQuestion *rQuestion = [self reinforceQustionWithQuestionID:question.qustoinID];

    if (rQuestion) {
        // 上次‘未做’该题，这次为‘做错’
        if (rQuestion.result == 0 && question.result != 0) {
            if (![self.dataBase open]) {
                return;
            }
            [self.dataBase executeUpdate:@"UPDATE tbl_reinforce SET result = (?) WHERE question_id = (?)", @(question.result), @(rQuestion.questionID)];
            [self.dataBase close];
        }
    } else {
        if (![self.dataBase open]) {
            return;
        }
        [self.dataBase executeUpdate:@"INSERT INTO tbl_reinforce VALUES (?, ?, ?, ?)", nil, @(question.qustoinID), @(question.result), @(0)];
        [self.dataBase close];
    }
}

- (ReinforceQuestion *)reinforceQustionWithQuestionID:(NSInteger)questionID
{
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE question_id = (?)", @(questionID)];
    ReinforceQuestion *question = nil;
    if ([result next]) {
        question = [[ReinforceQuestion alloc] init];
        question.reinforceID = [result intForColumn:REINFORCE_ID];
        question.questionID = [result intForColumn:QUESTION_ID_IN_REINFORCE];
        question.result = [result intForColumn:RESULT];
        question.status = [result intForColumn:STATUS];
    }
    [self.dataBase close];
    return question;
}

- (NSInteger)faultQuestionCount
{
    if (![self.dataBase open]) {
        return 0;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT COUNT(*) FROM tbl_reinforce WHERE status = 0 AND result <> 0"];
    while ([result next]) {
        return [result intForColumnIndex:0];
    }
    
    return 0;
}

- (NSInteger)missQuestionCount
{
    if (![self.dataBase open]) {
        return 0;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT COUNT(*) FROM tbl_reinforce WHERE status = 0 AND result = 0"];
    while ([result next]) {
        return [result intForColumnIndex:0];
    }
    
    return 0;
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

- (NSMutableDictionary *)answerCacheDic
{
    return [NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULTS dictionaryForKey:ANSWER_CACHE]];
}

@end
