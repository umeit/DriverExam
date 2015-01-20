//
//  QuestionBase.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/15.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBase : NSObject

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSArray *answerList;

@property (nonatomic) NSInteger trueAnswerIndex;

@property (nonatomic) NSInteger result;

@end
