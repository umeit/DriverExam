//
//  UserEntity.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userID = [aDecoder decodeIntegerForKey:@"userID"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _sex = [aDecoder decodeIntegerForKey:@"sex"];
        _age = [aDecoder decodeIntegerForKey:@"age"];
        _school = [aDecoder decodeIntegerForKey:@"school"];
        _mobile = [aDecoder decodeIntegerForKey:@"mobile"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.sex forKey:@"sex"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeInteger:self.school forKey:@"school"];
    [aCoder encodeInteger:self.mobile forKey:@"mobile"];
}

@end
