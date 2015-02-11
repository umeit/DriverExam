//
//  FileTools.h
//  DriverExam
//
//  Created by Liu Feng on 15/2/6.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTools : NSObject

+ (void)copyFileToDocuments:(NSString *)filePath withName:fileName;

+ (NSString *)dirDoc;

+ (BOOL)fileIsExitsOnDocuments:(NSString *)fileName;

@end
