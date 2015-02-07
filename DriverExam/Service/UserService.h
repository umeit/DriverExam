//
//  UserService.h
//  DriverExam
//
//  Created by Liu Feng on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserEntity;

typedef void(^RegisterBlock)(BOOL success, NSString *errorMgs);

@interface UserService : NSObject

- (void)registerUser:(UserEntity *)user block:(RegisterBlock)block;

@end
