//
//  PayHTTPClient.h
//  DriverExam
//
//  Created by Liu Feng on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPRequestOperationManager.h"

@interface PayHTTPClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
