//
//  ExamQuestionStore.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/29.
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
    
    if (IS_KM1) {
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
        
    } else if (IS_KM4) {
        // 第39章
        // 选择题3题
        [self.questionList addObjectsFromArray:[self questListWithSection:39 type:QUESTION_TYPE_CQ count:3]];
        // 多选题2题
        [self.questionList addObjectsFromArray:[self questListWithSection:39 type:QUESTION_TYPE_MCQ count:2]];
        
        // 第40章
        // 判断题6题
        [self.questionList addObjectsFromArray:[self questListWithSection:40 type:QUESTION_TYPE_TFNG count:6]];
        // 选择题5题
        [self.questionList addObjectsFromArray:[self questListWithSection:40 type:QUESTION_TYPE_CQ count:5]];
        // 多选题1题
        [self.questionList addObjectsFromArray:[self questListWithSection:40 type:QUESTION_TYPE_MCQ count:1]];
        
        // 第41章
        // 判断题3题
        [self.questionList addObjectsFromArray:[self questListWithSection:41 type:QUESTION_TYPE_TFNG count:3]];
        // 选择题3题
        [self.questionList addObjectsFromArray:[self questListWithSection:41 type:QUESTION_TYPE_CQ count:3]];
        
        // 第42章
        // 判断题3题
        [self.questionList addObjectsFromArray:[self questListWithSection:42 type:QUESTION_TYPE_TFNG count:3]];
        // 选择题3题
        [self.questionList addObjectsFromArray:[self questListWithSection:42 type:QUESTION_TYPE_CQ count:3]];
        
        // 第43章
        // 判断题5题
        [self.questionList addObjectsFromArray:[self questListWithSection:43 type:QUESTION_TYPE_TFNG count:5]];
        // 选择题4题
        [self.questionList addObjectsFromArray:[self questListWithSection:43 type:QUESTION_TYPE_CQ count:4]];
        // 多选题1题
        [self.questionList addObjectsFromArray:[self questListWithSection:43 type:QUESTION_TYPE_MCQ count:1]];
        
        // 第44章
        // 判断题4题
        [self.questionList addObjectsFromArray:[self questListWithSection:44 type:QUESTION_TYPE_TFNG count:4]];
        // 选择题3题
        [self.questionList addObjectsFromArray:[self questListWithSection:44 type:QUESTION_TYPE_CQ count:3]];
        // 多选题2题
        [self.questionList addObjectsFromArray:[self questListWithSection:44 type:QUESTION_TYPE_MCQ count:2]];
        
        // 第45章
        // 判断题1题
        [self.questionList addObjectsFromArray:[self questListWithSection:45 type:QUESTION_TYPE_TFNG count:1]];
        // 选择题1题
        [self.questionList addObjectsFromArray:[self questListWithSection:45 type:QUESTION_TYPE_CQ count:1]];
    }
    
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
    NSInteger qValue = 0;
    if (IS_KM1) {
        qValue = 1;
    }
    else if (IS_KM4) {
        qValue = 2;
    }
    
    self.questionFaultList = [[NSMutableArray alloc] init];
    
    for (QuestionBase *question in self.questionList) {
        // 多选题
        if (question.correctIndexs) {
            if ([question.results isEqualToSet:question.correctIndexs]) {
                score += qValue;
                continue;
            }
        }
        else {
            if (question.result == question.correctIndex) {
                score += qValue;
                continue;
            }
        }
        
        // 将错题加入强化题库
        [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:question];
        // 将错题加入错题回顾
        [self.questionFaultList addObject:question];
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

- (void)addCacheQuestion:(QuestionBase *)question
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
        
    // 多选题
    } else if (type == QUESTION_TYPE_MCQ) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tbl_question WHERE c_index LIKE '%d.%%' AND length(answer) > 1 ORDER BY RANDOM() LIMIT %d", section, count];
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
