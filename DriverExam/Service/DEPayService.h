//
//  DEPayService.h
//  DriverExam
//
//  Created by 沈 湛 on 15/2/8.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

@interface DEPayService : NSObject

typedef void(^checkReceiptBlock)(BOOL success);

/** 验证用户的购买凭证 */
- (void)checkReceipt:(NSString *)receipt block:(checkReceiptBlock)block;

/** 记录用户的购买信息 */
- (void)markPaymentInfo:(NSString *)receipt userInfo:(UserEntity *)user;

@end
