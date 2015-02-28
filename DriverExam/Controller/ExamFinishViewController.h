//
//  ExamFinishViewController.h
//  DriverExam
//
//  Created by Liu Feng on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamFinishViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *examCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *examResultImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end
