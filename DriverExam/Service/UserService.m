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
                                  if ([ret integerValue] == 0) {
                                      id uID = [responseObject objectForKey:@"uID"];
                                      block([uID integerValue], nil);
                                  } else {
                                      block(0, nil);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  block(0, nil);
                              }];
}

- (void)schoolAndLocalList:(SchollAndLocalBlock)block
{
    [[DEHTTPClient sharedClient] GET:@"/school"
                          parameters:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"%@", responseObject);
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
                             }];
}


/** 保存用户信息到本地 */
- (void)saveUser:(UserEntity *)user
{
    [USER_DEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:user]
                      forKey:CURRENT_USER];
}

- (NSDictionary *)userDic:(UserEntity *)user
{
    return @{@"name": user.name, @"mobile": user.mobile, @"age":@(user.age),
             @"sex": @(user.sex), @"schoolID": @(user.school), @"system": @(1)};
}

@end
