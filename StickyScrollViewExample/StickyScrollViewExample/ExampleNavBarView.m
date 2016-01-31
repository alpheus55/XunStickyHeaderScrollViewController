//
//  ExampleNavBarView.m
//  StickyScrollViewExample
//
//  Created by yanglixun on 16/2/1.
//  Copyright © 2016年 com.xun.example. All rights reserved.
//

#import "ExampleNavBarView.h"

@implementation ExampleNavBarView



-(void)setNavBarSelected:(NSInteger)index
{

    [_tab1 setSelected:index==0];
    [_tab2 setSelected:index==1];
}

- (IBAction)tabAction:(UIButton *)sender {
    
    if(self.tabActionBlock)
    self.tabActionBlock(sender.tag-1000);
    
}

@end
