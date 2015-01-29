//
//  ExamViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/29.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExamViewController.h"

@interface ExamViewController ()
@property (nonatomic)  NSInteger secondsCountDown;
@property (strong, nonatomic) NSTimer *countDownTimer;
@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.examTimeItem setTitle:@"45:00"];
    
    self.secondsCountDown = 45 * 60; //倒计时
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)timeFireMethod {
    self.secondsCountDown--;
    NSInteger m = self.secondsCountDown / 60;
    [self.examTimeItem setTitle:[NSString stringWithFormat:@"%@:%@", [@(m) stringValue], [@(self.secondsCountDown - (m * 60)) stringValue]]];

    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
    }
}
@end
