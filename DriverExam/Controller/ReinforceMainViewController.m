//
//  ReinforceMainViewController.m
//  DriverExam
//
//  Created by 沈 湛 on 15/1/23.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ReinforceMainViewController.h"
#import "ReinforceQuestionStore.h"

@interface ReinforceMainViewController ()

@end

@implementation ReinforceMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faultQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] faultQuestionCount]) stringValue];
    self.missQuestionCountLabel.text = [@([[ReinforceQuestionStore reinforceStore] missQuestionCount]) stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
