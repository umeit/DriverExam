//
//  ReviewViewController.h
//  DriverExam
//
//  Created by Liu Feng on 15/2/2.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "AnswerViewController.h"

#define REVIEW_TYPE_EXAM       0
#define REVIEW_TYPE_REINFORCE  1

@interface ReviewViewController : AnswerViewController

@property (nonatomic) NSInteger reviewType;

@end
