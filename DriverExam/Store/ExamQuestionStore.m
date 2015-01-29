//
//  ExamQuestionStore.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamQuestionStore.h"
#import "FMDatabase.h"

#define QUESTION_TYPE_TFNG 1   // 判断题
#define QUESTION_TYPE_CQ   2   // 选择题

static ExamQuestionStore *examQuestionStore = nil;

@interface ExamQuestionStore ()

@property (strong, nonatomic) NSMutableArray *questionList;

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
}


#pragma mark - Private

- (NSMutableArray *)questListWithSection:(NSInteger)section type:(NSInteger)type count:(NSInteger)count
{
    if (![self.dataBase open]) {
        return nil;
    }
    
    NSMutableArray *questionList = [[NSMutableArray alloc] init];
    FMResultSet *result;
    
    // 判断题
    if (type == QUESTION_TYPE_TFNG) {
        result = [self.dataBase executeQuery:@"SELECT * FROM tbl_library_general WHERE  `order` LIKE '(?).%' AND answer_c is null AND answer_a IS NOT null ORDER BY RANDOM() LIMIT (?)", @(section), @(count)];
    
    // 选择题
    } else if (type == QUESTION_TYPE_CQ) {
        result = [self.dataBase executeQuery:@"SELECT * FROM tbl_library_general WHERE  `order` LIKE '(?).%' AND answer_c is Not null OR answer_a is null ORDER BY RANDOM() LIMIT (?)", @(section), @(count)];
    }
    
    while ([result next]) {
        QuestionBase *question = [self questionWithResult:result];
        [questionList addObject:question];
    }
    
    [self.dataBase close];
    return questionList;
}

@end
