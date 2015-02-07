//
//  PayHTTPClient.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "PayHTTPClient.h"

static NSString *const BaseURLString = @"http://pay.youche.com/ios/receipt";

@implementation PayHTTPClient

+ (instancetype)sharedClient
{
    static PayHTTPClient *client = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client = [[PayHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    return client;
}

@end
