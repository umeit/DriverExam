//
//  DEPayService.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/8.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "DEPayService.h"
#import "PayHTTPClient.h"

@implementation DEPayService

- (void)checkReceipt:(NSString *)receipt block:(checkReceiptBlock)block
{
    [[PayHTTPClient sharedClient] POST:@"/ios/receipt"
                            parameters:@{@"receipt": receipt}
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   id status = [responseObject objectForKey:@"status"];
                                   if (status && [status integerValue] == 0) {
                                       block(YES);
                                       [USER_DEFAULTS setBool:YES forKey:@"IsPay"];
                                   } else {
                                       block(NO);
                                   }
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   block(NO);
                               }];
}

- (void)markPaymentInfo:(NSString *)receipt userInfo:(UserEntity *)user
{
    
}

@end
