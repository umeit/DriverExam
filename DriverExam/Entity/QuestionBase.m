//
//  QuestionBase.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/15.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "QuestionBase.h"

@implementation QuestionBase

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _qustoinID = [aDecoder decodeIntegerForKey:@"qustoinID"];
        _content = [aDecoder decodeObjectForKey:@"content"];
        _answerList = [aDecoder decodeObjectForKey:@"answerList"];
        _correctIndex = [aDecoder decodeIntegerForKey:@"correctIndex"];
        _result = [aDecoder decodeIntegerForKey:@"result"];
        _correctIndexs = [aDecoder decodeObjectForKey:@"correctIndexs"];
        _results = [aDecoder decodeObjectForKey:@"results"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.qustoinID forKey:@"qustoinID"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.answerList forKey:@"answerList"];
    [aCoder encodeInteger:self.correctIndex forKey:@"correctIndex"];
    [aCoder encodeInteger:self.result forKey:@"result"];
    [aCoder encodeObject:self.correctIndexs forKey:@"correctIndexs"];
    [aCoder encodeObject:self.results forKey:@"results"];
}

@end
