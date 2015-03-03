//
//  CityListTableViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/3/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "CityListTableViewController.h"
#import "SchoolListViewController.h"

@interface CityListTableViewController ()

@end

@implementation CityListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"CityAndSchool" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:path];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.cityList = [[dic objectForKey:@"school"] objectForKey:@"reg"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.cityList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.cityList objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    NSInteger cityIndex = [self.tableView indexPathForSelectedRow].row;
    NSDictionary *dic = [self.cityList objectAtIndex:cityIndex];
    
    if ([destination respondsToSelector:@selector(setCityID:)]) {
        [destination setValue:[dic objectForKey:@"id"] forKey:@"cityID"];
    }
}

@end
