//
//  ExamQuestionStore.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamQuestionStore.h"
#import "FMDatabase.h"

static ExamQuestionStore *examQuestionStore = nil;

@interface ExamQuestionStore ()

@property (strong, nonatomic) NSArray *questionList;

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
    
    
    [self questListWithSection:1 type:1 count:14];
    
    
    
    
}


#pragma mark - Private

- (NSArray *)questListWithSection:(NSInteger)section type:(NSInteger)type count:(NSInteger)count
{
    if (![self.dataBase open]) {
        return nil;
    }
    
    // 判断题
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_library_general WHERE  `order` LIKE '(?).%' AND answer_c is null AND answer_a IS NOT null ORDER BY RANDOM() LIMIT (?)", @(section), @(count)];
    
    while ([result next]) {
        QuestionBase *question = [self questionWithResult:result];
    }
    
    [self.dataBase close];
    return nil;
}

@end
