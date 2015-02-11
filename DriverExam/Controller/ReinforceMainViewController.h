//
//  ReinforceMainViewController.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/23.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReinforceMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *faultQuestionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *missQuestionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *reinforcedQuestionCountLabel;

@end
