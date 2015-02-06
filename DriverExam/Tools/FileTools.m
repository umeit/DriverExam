//
//  FileTools.m
//  DriverExam
//
//  Created by 沈 湛 on 15/2/6.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "FileTools.h"

@implementation FileTools


+ (void)copyFileToDocuments:(NSString *)filePath withName:fileName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSData *fileData = [fm contentsAtPath:filePath];
    NSString *newFilePath = [[FileTools dirDoc] stringByAppendingPathComponent:fileName];
    [fm createFileAtPath:newFilePath contents:fileData attributes:nil];
}

+ (NSString *)dirDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}

+ (BOOL)fileIsExitsOnDocuments:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[[FileTools dirDoc] stringByAppendingPathComponent:fileName]];
}

@end
