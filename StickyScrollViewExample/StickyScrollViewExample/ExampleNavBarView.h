//
//  ExampleNavBarView.h
//  StickyScrollViewExample
//
//  Created by yanglixun on 16/2/1.
//  Copyright © 2016年 com.xun.example. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NavBarBlock)(NSInteger index);
@interface ExampleNavBarView : UIView
{
    __weak IBOutlet UIButton *_tab1;
    __weak IBOutlet UIButton *_tab2;
    
}

@property(nonatomic, copy)NavBarBlock tabActionBlock;

-(void)setNavBarSelected:(NSInteger)index;
- (IBAction)tabAction:(UIButton *)sender;

@end
