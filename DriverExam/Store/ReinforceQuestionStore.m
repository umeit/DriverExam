//
//  ReinforceQuestionStore.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/26.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceQuestionStore.h"
#import "FMDatabase.h"

#define CURRENT_QUESTION_INDEX_FOR_REINFORCE @"CurrentQuestionIndexForReinforce"

@implementation ReinforceQuestionStore


- (id)init
{
    self = [super init];
    if (self) {
        [USER_DEFAULTS registerDefaults:@{CURRENT_QUESTION_INDEX_FOR_REINFORCE: @0}];
    }
    return self;
}

#pragma mark - Override

- (QuestionBase *)currentQuestion
{
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM tbl_reinforce WHERE status = 0 LIMIT 1 OFFSET (?)",
                           [USER_DEFAULTS integerForKey:CURRENT_QUESTION_INDEX_FOR_REINFORCE]];
    while ([result next]) {
        
        return nil;
    }
    return nil;
}

@end
