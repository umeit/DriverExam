//
//  PayHTTPClient.h
//  DriverExam
//
//  Created by 沈 湛 on 15/2/7.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPRequestOperationManager.h"

@interface PayHTTPClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
