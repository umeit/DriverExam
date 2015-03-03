//
//  ADWebViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/3/2.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ADWebViewController.h"

@interface ADWebViewController ()

@end

@implementation ADWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url =[NSURL URLWithString:@"http://www.youche.com"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
