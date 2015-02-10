//
//  UserService.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "UserService.h"
#import "DEHTTPClient.h"
#import "UserEntity.h"

@implementation UserService

- (void)registerUser:(UserEntity *)user block:(RegisterBlock)block
{
    [[DEHTTPClient sharedClient] POST:@"/login"
                           parameters:[self userDic:user]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  id ret = [responseObject objectForKey:@"ret"];
                                  if ([ret integerValue] == 1) {
                                      block(YES, nil);
                                  } else {
                                      block(NO, nil);
                                  }
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

- (NSDictionary *)userDic:(UserEntity *)user
{
    return @{@"name": user.name, @"mobile": user.mobile, @"sex": @(user.sex), @"schoolID": @(user.school)};
}

@end
