//
//  XunStickyHeaderScrollViewController.h
//  JuHui
//
//  Created by yanglixun on 16/1/17.
//  Copyright © 2016年 Caibo-Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XunStickyHeaderScrollViewController;
typedef void(^XunStickyHeaderScrollViewControllerBlock)(XunStickyHeaderScrollViewController *viewController, NSInteger selectedIndex, UIViewController *selectedViewController);

@interface XunStickyHeaderScrollViewController : UIViewController<UIScrollViewDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet    UIScrollView *mainContainer;

@property(strong, nonatomic, readonly)  UIView *headerView;
@property(nonatomic)                    CGFloat headerHeight;

@property(strong, nonatomic, readonly)  UIView *navBar;
@property(nonatomic)                    CGFloat navBarHeight;

@property(strong, nonatomic)            NSArray *viewControllers;
@property(copy, nonatomic)              XunStickyHeaderScrollViewControllerBlock sticyHeaderDidSelectedBlock;

-(void)setHeaderView:(UIView *)headerView navBar:(UIView *)navBar selectedBlock:(XunStickyHeaderScrollViewControllerBlock)selectedBlock;

-(void)selectCurrentViewControllerAtIndex:(NSInteger)index;
@end
