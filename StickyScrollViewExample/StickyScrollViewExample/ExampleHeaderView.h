//
//  ExampleHeaderView.h
//  StickyScrollViewExample
//
//  Created by yanglixun on 16/1/31.
//  Copyright © 2016年 com.xun.example. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ExampleHeaderView : UIView
{
    
    __weak IBOutlet UIScrollView *_scrollView;
}
-(void)configHeaderView;

-(int)getHeaderViewHeight;
@end
