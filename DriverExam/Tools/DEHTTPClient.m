//
//  DEHTTPClient.m
//  DriverExam
//
//  Created by Liu Feng on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "DEHTTPClient.h"

static NSString *const BaseURLString = @"http://appapi.youche.com/";

@implementation DEHTTPClient

+ (instancetype)sharedClient
{
    static DEHTTPClient *client = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client = [[DEHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    return client;
}

@end
