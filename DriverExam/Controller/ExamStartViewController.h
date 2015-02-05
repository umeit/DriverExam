//
//  ExamStartViewController.h
//  DriverExam
//
//  Created by 沈 湛 on 15/2/5.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamStartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *passScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *ExamTimeLabel;
@end
