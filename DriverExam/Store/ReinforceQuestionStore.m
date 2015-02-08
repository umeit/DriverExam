//
//  ReinforceQuestionStore.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/26.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceQuestionStore.h"
#import "FMDatabase.h"
#import "ReinforceQuestion.h"
#import "QuestionBase.h"

#define REINFORCE_ID @"id"
#define QUESTION_ID_IN_REINFORCE @"question_id"
#define RESULT @"result"
#define STATUS @"status"

#define REINFORCED @1
#define REINFORCE  @0

#define CURRENT_QUESTION_INDEX_FOR_REINFORCE @"CurrentQuestionIndexForReinforce"
#define CURRENT_QUESTION_INDEX_FOR_REINFORCED @"CurrentQuestionIndexForReinforced"

static ReinforceQuestionStore *reinforceStore = nil;

@implementation ReinforceQuestionStore

+ (ReinforceQuestionStore *)reinforceStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reinforceStore = [[ReinforceQuestionStore alloc] init];
    });
    
    return reinforceStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        [USER_DEFAULTS registerDefaults:@{CURRENT_QUESTION_INDEX_FOR_REINFORCE: @0}];
    }
    return self;
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
        [self.dataBase executeUpdate:@"INSERT INTO tbl_reinforce VALUES (?, ?, ?, ?)", nil, @(question.qustoinID), @(question.result), REINFORCE];
        [self.dataBase close];
    }
}

- (void)questionDidReinforced:(QuestionBase *)question
{
    if (![self.dataBase open]) {
        return;
    }
    [self.dataBase executeUpdate:@"UPDATE tbl_reinforce SET status = (?) WHERE question_id = (?)", REINFORCED, @(question.qustoinID)];
    [self.dataBase close];
}

- (ReinforceQuestion *)reinforceQustionWithQuestionID:(NSInteger)questionID
{
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE question_id = (?)", @(questionID)];
    ReinforceQuestion *question = nil;
    if ([result next]) {
        question = [self reinforceQuestionWithResult:result];
    }
    [self.dataBase close];
    return question;
}

- (NSInteger)faultQuestionCount
{
    if (![self.dataBase open]) {
        return 0;
    }
    
    NSInteger count = 0;
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT COUNT(*) FROM tbl_reinforce WHERE status = 0 AND result <> 0"];
    while ([result next]) {
        count = [result intForColumnIndex:0];
    }
    
    [self.dataBase close];
    return count;
}

- (NSInteger)missQuestionCount
{
    if (![self.dataBase open]) {
        return 0;
    }
    
    NSInteger count = 0;
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT COUNT(*) FROM tbl_reinforce WHERE status = 0 AND result = 0"];
    while ([result next]) {
        count = [result intForColumnIndex:0];
    }
    
    [self.dataBase close];
    return count;
}

- (NSInteger)reinforcedQuestionCount
{
    if (![self.dataBase open]) {
        return 0;
    }
    
    NSInteger count = 0;
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT COUNT(*) FROM tbl_reinforce WHERE status = 1"];
    while ([result next]) {
        count =  [result intForColumnIndex:0];
    }
    
    [self.dataBase close];
    return count;
}

- (QuestionBase *)nextQuestionWhenLastQuestionWsaCorrect
{
    if (![self.dataBase open]) {
        return 0;
    }
    NSInteger index = [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX_FOR_REINFORCE];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE status = 0 LIMIT 1 OFFSET (?)", @(--index)];
    ReinforceQuestion *question = nil;
    if ([result next]) {
        question = [self reinforceQuestionWithResult:result];
        [USER_DEFAULTS setInteger:++index forKey:CURRENT_QUESTION_INDEX_FOR_REINFORCE];
        [self.dataBase close];
        return [[QuestionStore exercisesStore] questionWithIDOnDB:question.questionID];
    }
    [self.dataBase close];
    return nil;
}

- (QuestionBase *)currentReinforcedQuestion
{
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE status = 1 LIMIT 1 OFFSET 0"];
    
    [USER_DEFAULTS setInteger:1 forKey:CURRENT_QUESTION_INDEX_FOR_REINFORCED];
    ReinforceQuestion *question = nil;
     if ([result next]) {
        question = [self reinforceQuestionWithResult:result];
        [self.dataBase close];
        return [[QuestionStore exercisesStore] questionWithIDOnDB:question.questionID];
    }
    [self.dataBase close];
    return nil;

}

- (QuestionBase *)nextReinforcedQuestion
{
    if (![self.dataBase open]) {
        return 0;
    }
    NSInteger index = [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX_FOR_REINFORCED];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE status = 1 LIMIT 1 OFFSET (?)", @(index)];
    ReinforceQuestion *question = nil;
    if ([result next]) {
        question = [self reinforceQuestionWithResult:result];
        [USER_DEFAULTS setInteger:++index forKey:CURRENT_QUESTION_INDEX_FOR_REINFORCED];
        [self.dataBase close];
        return [[QuestionStore exercisesStore] questionWithIDOnDB:question.questionID];
    }
    [self.dataBase close];
    return nil;
}

#pragma mark - Override

- (QuestionBase *)currentQuestion
{
    if (![self.dataBase open]) {
        return nil;
    }
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE status = 0 LIMIT 1 OFFSET 0"];
    [USER_DEFAULTS setInteger:1 forKey:CURRENT_QUESTION_INDEX_FOR_REINFORCE];
    ReinforceQuestion *question = nil;
    if ([result next]) {
        question = [self reinforceQuestionWithResult:result];
        [self.dataBase close];
        return [[QuestionStore exercisesStore] questionWithIDOnDB:question.questionID];
    }
    [self.dataBase close];
    return nil;
}

- (QuestionBase *)nextQuestion
{
    if (![self.dataBase open]) {
        return 0;
    }
    NSInteger index = [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX_FOR_REINFORCE];
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE status = 0 LIMIT 1 OFFSET (?)", @(index)];
    ReinforceQuestion *question = nil;
    if ([result next]) {
        question = [self reinforceQuestionWithResult:result];
        [USER_DEFAULTS setInteger:++index forKey:CURRENT_QUESTION_INDEX_FOR_REINFORCE];
        [self.dataBase close];
        return [[QuestionStore exercisesStore] questionWithIDOnDB:question.questionID];
    }
    [self.dataBase close];
    return nil;
}


#pragma mark - Private

- (ReinforceQuestion *)reinforceQuestionWithResult:(FMResultSet *)result
{
    ReinforceQuestion *question = [[ReinforceQuestion alloc] init];
    question.reinforceID = [result intForColumn:REINFORCE_ID];
    question.questionID = [result intForColumn:QUESTION_ID_IN_REINFORCE];
    question.result = [result intForColumn:RESULT];
    question.status = [result intForColumn:STATUS];
    
    return question;
}
@end
