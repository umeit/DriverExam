//
//  UserEntity.h
//  DriverExam
//
//  Created by Liu Feng on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject <NSCoding>

@property (nonatomic) NSInteger userID;

@property (strong, nonatomic) NSString *name;

@property (nonatomic) NSInteger sex;

@property (nonatomic) NSInteger age;

@property (nonatomic) NSInteger school;

@property (nonatomic) NSInteger mobile;

@end