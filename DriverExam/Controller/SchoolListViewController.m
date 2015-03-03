//
//  SchoolListViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/3/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "SchoolListViewController.h"

@interface SchoolListViewController ()

@end

@implementation SchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"CityAndSchool" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:path];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.schoolList = [[dic objectForKey:@"school"] objectForKey:[@(self.cityID) stringValue]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.schoolList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.schoolList objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger schoolIndex = [self.tableView indexPathForSelectedRow].row;
    NSDictionary *dic = [self.schoolList objectAtIndex:schoolIndex];
    [USER_DEFAULTS setObject:[dic objectForKey:@"id"] forKey:@"schoolID"];
    [USER_DEFAULTS setObject:[dic objectForKey:@"name"] forKey:@"schoolName"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
