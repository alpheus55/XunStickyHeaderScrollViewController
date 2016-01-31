//
//  IndexViewController.m
//  StickyScrollViewExample
//
//  Created by yanglixun on 16/2/1.
//  Copyright © 2016年 com.xun.example. All rights reserved.
//

#import "IndexViewController.h"

#import "ExampleHeaderView.h"
#import "ExampleNavBarView.h"
#import "ExampleTableViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [self.navigationItem setTitle:@"StickyScrollViewExample"];
    
    ExampleHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ExampleHeaderView" owner:self options:nil] lastObject];
    [headerView configHeaderView];
    
    ExampleNavBarView *navBarView = [[[NSBundle mainBundle] loadNibNamed:@"ExampleNavBarView" owner:self options:nil] lastObject];
    [navBarView setTabActionBlock:^(NSInteger index){
        [self selectCurrentViewControllerAtIndex:index];
    }];
    
    
    [self setHeaderHeight:[headerView getHeaderViewHeight]];
    [self setNavBarHeight:40];
    [self setHeaderView:headerView navBar:navBarView selectedBlock:^(XunStickyHeaderScrollViewController *viewController, NSInteger selectedIndex, UIViewController *selectedViewController) {
        
        [navBarView setNavBarSelected:selectedIndex];
    }];
    
    
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<2; i++) {
        
        ExampleTableViewController *tableViewController = [[ExampleTableViewController alloc] initWithNibName:@"ExampleTableViewController" bundle:nil];
        [vcs addObject:tableViewController];
    }
    [self setViewControllers:vcs];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
