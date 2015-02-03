//
//  ExamQuestionStore.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamQuestionStore.h"
#import "FMDatabase.h"
#import "QuestionBase.h"
#import "FMResultSet.h"
#import "ReinforceQuestionStore.h"

#define QUESTION_TYPE_TFNG  1   // 判断题
#define QUESTION_TYPE_CQ    2   // 选择题
#define QUESTION_TYPE_MCQ   3   // 多择题

#define EXAM_QUESTION_INDEX_KEY @"ExamQuestionIndexKey"
#define EXAM_QUESTION_FAULT_INDEX_KEY @"ExamQuestionFaultIndexKey"
#define ANSWER_CACHE_FOR_EXAM @"AnswerCacheForExam"

static ExamQuestionStore *examQuestionStore = nil;

@interface ExamQuestionStore ()

@property (strong, nonatomic) NSMutableArray *questionList;

@property (strong, nonatomic) NSMutableArray *questionFaultList;

@end

@implementation ExamQuestionStore

+ (ExamQuestionStore *)examQuestionStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        examQuestionStore = [[ExamQuestionStore alloc] init];
    });
    return examQuestionStore;
}

- (void)initNewExam
{
    self.questionList = [[NSMutableArray alloc] init];
    
    // 第1章
    // 判断题14题
    [self.questionList addObjectsFromArray:[self questListWithSection:1 type:QUESTION_TYPE_TFNG count:14]];
    // 选择题21题
    [self.questionList addObjectsFromArray:[self questListWithSection:1 type:QUESTION_TYPE_CQ count:21]];
    
    // 第2章
    // 判断题14题
    [self.questionList addObjectsFromArray:[self questListWithSection:2 type:QUESTION_TYPE_TFNG count:14]];
    // 选择题21题
    [self.questionList addObjectsFromArray:[self questListWithSection:2 type:QUESTION_TYPE_CQ count:21]];
    
    // 第3章
    // 判断题6题
    [self.questionList addObjectsFromArray:[self questListWithSection:3 type:QUESTION_TYPE_TFNG count:6]];
    // 选择题9题
    [self.questionList addObjectsFromArray:[self questListWithSection:3 type:QUESTION_TYPE_CQ count:9]];

    // 第4章
    // 判断题6题
    [self.questionList addObjectsFromArray:[self questListWithSection:4 type:QUESTION_TYPE_TFNG count:6]];
    // 选择题9题
    [self.questionList addObjectsFromArray:[self questListWithSection:4 type:QUESTION_TYPE_CQ count:9]];
    
    [USER_DEFAULTS setInteger:0 forKey:EXAM_QUESTION_INDEX_KEY];
    
    [USER_DEFAULTS registerDefaults:@{ANSWER_CACHE_FOR_EXAM: @{}}];
}

- (void)examClear
{
    self.questionList = nil;
    self.questionFaultList = nil;
}

- (void)examFinish
{
    NSInteger score = 0;
    
    self.questionFaultList = [[NSMutableArray alloc] init];
    
    for (QuestionBase *question in self.questionList) {
        if (question.result == question.correctIndex) {
            score += 1;
        }
        else {
            // 将错题加入强化题库
            [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:question];
            
            // 将错题加入错题回顾
            [self.questionFaultList addObject:question];
        }
    }
    
    if (![self.dataBase open]) {
        return;
    }
    
    [self.dataBase executeUpdate:@"INSERT INTO tbl_exam VALUES (?, ?)", nil, @(score)];
    
    [self.dataBase close];
    
    self.lastScore = score;
}

- (NSInteger)examCount
{
    NSInteger count = 0;
    
    if (![self.dataBase open]) {
        return count;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT COUNT(*) FROM tbl_exam"];
    
    while ([result next]) {
        count = [result intForColumnIndex:0];
    }
    
    [self.dataBase close];
    
    return count;
}

- (double)average
{
    double score = .0;
    
    if (![self.dataBase open]) {
        return score;
    }
    
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT AVG(score) FROM tbl_exam"];
    while ([result next]) {
        score = [result intForColumnIndex:0];
    }
    
    [self.dataBase close];
    
    return score;
}

- (NSInteger)questionCuont
{
    return [self.questionList count];
}

- (NSInteger)currentQuestionIndex
{
    return [USER_DEFAULTS integerForKey:EXAM_QUESTION_INDEX_KEY];
}

- (QuestionBase *)nextQuestion
{
    NSInteger i = [USER_DEFAULTS integerForKey:EXAM_QUESTION_INDEX_KEY];
    QuestionBase *q = i >= self.questionList.count ? nil : [self.questionList objectAtIndex:i];
    [USER_DEFAULTS setInteger:++i forKey:EXAM_QUESTION_INDEX_KEY];
    return q;
}

- (QuestionBase *)prevQustion
{
    NSInteger i = [USER_DEFAULTS integerForKey:EXAM_QUESTION_INDEX_KEY];
    i--;
    i--;
    QuestionBase *q = i >= self.questionList.count ? nil : [self.questionList objectAtIndex:i];
    [USER_DEFAULTS setInteger:++i forKey:EXAM_QUESTION_INDEX_KEY];
    return q;
}

- (QuestionBase *)nextFaultQuestion
{
    NSInteger i = [USER_DEFAULTS integerForKey:EXAM_QUESTION_FAULT_INDEX_KEY];
    QuestionBase *q = [self.questionFaultList objectAtIndex:i];
    [USER_DEFAULTS setInteger:++i forKey:EXAM_QUESTION_FAULT_INDEX_KEY];
    return q;
}

- (QuestionBase *)prevFaultQuestion
{
    NSInteger i = [USER_DEFAULTS integerForKey:EXAM_QUESTION_FAULT_INDEX_KEY];
    i--;
    i--;
    QuestionBase *q = [self.questionFaultList objectAtIndex:i];
    [USER_DEFAULTS setInteger:++i forKey:EXAM_QUESTION_FAULT_INDEX_KEY];
    return q;
}

- (void)saveExamRusult:(QuestionBase *)question
{
    [self.questionList replaceObjectAtIndex:[self.questionList indexOfObject:question]
                                 withObject:question];
}

- (void)addcaCheQuestion:(QuestionBase *)question
{
    NSMutableDictionary *dic = [self answerCacheDic];
    [dic setObject:[NSKeyedArchiver archivedDataWithRootObject:question] forKey:[@(question.qustoinID) stringValue]];
    [USER_DEFAULTS setObject:dic forKey:ANSWER_CACHE_FOR_EXAM];
}

- (QuestionBase *)questionWithIDOnCache:(NSInteger)questionID
{
    NSData *data = [[self answerCacheDic] objectForKey:[@(questionID) stringValue]];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (NSInteger)currentFaultQuestionIndex
{
    return [USER_DEFAULTS integerForKey:EXAM_QUESTION_FAULT_INDEX_KEY];
}

- (NSInteger)faultquestionCuont
{
    return [self.questionFaultList count];
}

- (void)resetReviewIndex
{
    [USER_DEFAULTS setInteger:0 forKey:EXAM_QUESTION_FAULT_INDEX_KEY];
}

#pragma mark - Private

- (NSMutableDictionary *)answerCacheDic
{
    return [NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULTS dictionaryForKey:ANSWER_CACHE_FOR_EXAM]];
}

- (NSMutableArray *)questListWithSection:(NSInteger)section type:(NSInteger)type count:(NSInteger)count
{
    if (![self.dataBase open]) {
        return nil;
    }
    
    NSMutableArray *questionList = [[NSMutableArray alloc] init];
    FMResultSet *result;
    
    // 判断题
    if (type == QUESTION_TYPE_TFNG) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tbl_question WHERE c_index LIKE '%d.%%' AND answer_c is null ORDER BY RANDOM() LIMIT %d", section, count];
        result = [self.dataBase executeQuery:sql];
    
    // 选择题
    } else if (type == QUESTION_TYPE_CQ) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tbl_question WHERE c_index LIKE '%d.%%' AND answer_c is Not null ORDER BY RANDOM() LIMIT %d", section, count];
        result = [self.dataBase executeQuery:sql];
    }
    
    while ([result next]) {
        QuestionBase *question = [self questionWithResult:result];
        [questionList addObject:question];
    }
    
    [self.dataBase close];
    return questionList;
}

@end
