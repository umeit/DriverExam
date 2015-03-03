//
//  DEPayService.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/8.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "DEPayService.h"
#import "PayHTTPClient.h"
#import "DEHTTPClient.h"

@implementation DEPayService

- (void)checkReceipt:(NSString *)receipt block:(baseBlock)block
{
    [[PayHTTPClient sharedClient] POST:@"/ios/receipt"
                            parameters:@{@"receipt": receipt}
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   id status = [responseObject objectForKey:@"status"];
                                   if (status && [status integerValue] == 0) {
                                       block(YES);
                                   } else {
                                       block(NO);
                                   }
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   block(NO);
                               }];
}

- (void)markPaymentInfo:(NSString *)transactionIdentifier
               userInfo:(UserEntity *)user
                  block:(baseBlock)block
{
    [[DEHTTPClient sharedClient] POST:@"/markpay"
                           parameters:@{@"uID": @(user.userID), @"tID":transactionIdentifier, @"price":@(12.0)}
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  id ret = [responseObject objectForKey:@"ret"];
                                  if ([ret integerValue] == 0) {
                                      block(YES);
                                  } else {
                                      block(NO);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  block(NO);
                              }];
}

@end
