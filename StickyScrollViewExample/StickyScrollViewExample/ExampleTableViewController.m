//
//  ExampleTableViewController.m
//  StickyScrollViewExample
//
//  Created by yanglixun on 16/2/1.
//  Copyright © 2016年 com.xun.example. All rights reserved.
//

#import "ExampleTableViewController.h"

@interface ExampleTableViewController ()

@end

@implementation ExampleTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    [cell.textLabel setText:[NSString stringWithFormat:@"row %ld", indexPath.row]];
    
    return cell;
}


@end
