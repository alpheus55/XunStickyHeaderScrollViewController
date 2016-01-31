//
//  ViewController.m
//  StickyScrollViewExample
//
//  Created by YangLiXun on 16/1/18.
//  Copyright © 2016年 com.xun.example. All rights reserved.
//

#import "ViewController.h"

#import "IndexViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"StickyScrollViewExample"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)showExampleAction:(id)sender {
    
    
    IndexViewController *indexViewController = [[IndexViewController alloc] init];
    [self.navigationController pushViewController:indexViewController animated:YES];
}



@end
