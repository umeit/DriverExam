//
//  SchoolListViewController.h
//  DriverExam
//
//  Created by Liu Feng on 15/3/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolListViewController : UITableViewController

@property (nonatomic) NSInteger cityID;

@property (strong, nonatomic) NSArray *schoolList;

@end
