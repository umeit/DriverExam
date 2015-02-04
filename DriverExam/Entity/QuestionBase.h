//
//  QuestionBase.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/15.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define QUESTION_TYPE_TFNG  1   // 判断题
//#define QUESTION_TYPE_CQ    2   // 选择题
//#define QUESTION_TYPE_MCQ   3   // 多择题

@interface QuestionBase : NSObject <NSCoding>

@property (nonatomic) NSInteger qustoinID;

@property (strong, nonatomic) NSString *order;

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSMutableArray *answerList;

//@property (nonatomic) NSInteger type;

/** 正确答案索引 */
@property (nonatomic) NSInteger correctIndex;

/** 多选题正确答案索引 */
@property (strong, nonatomic) NSMutableSet *correctIndexs;

/** 答题结果 */
@property (nonatomic) NSInteger result;

/** 多选题答题结果 */
@property (strong, nonatomic) NSMutableSet *results;

@end
