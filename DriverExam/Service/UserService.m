//
//  UserService.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "UserService.h"
#import "DEHTTPClient.h"

@implementation UserService

- (void)registerUser:(UserEntity *)user block:(RegisterBlock)block
{
    [[DEHTTPClient sharedClient] POST:@"login" parameters:@{}
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  block(YES, nil);
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  block(YES, nil);
                              }];
}

- (void)saveUser:(UserEntity *)user
{
    [USER_DEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:user]
                      forKey:CURRENT_USER];
}

@end
