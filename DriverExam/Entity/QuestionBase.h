//
//  QuestionBase.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/15.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBase : NSObject <NSCoding>

@property (nonatomic) NSInteger qustoinID;

@property (strong, nonatomic) NSString *order;

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSMutableArray *answerList;

@property (nonatomic) NSInteger correctIndex;

/** 答题结果 */
@property (nonatomic) NSInteger result;

@end
