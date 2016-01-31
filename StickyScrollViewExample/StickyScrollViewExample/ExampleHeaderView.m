//
//  ExampleHeaderView.m
//  StickyScrollViewExample
//
//  Created by yanglixun on 16/1/31.
//  Copyright © 2016年 com.xun.example. All rights reserved.
//

#import "ExampleHeaderView.h"
#import <Masonry/Masonry.h>

@implementation ExampleHeaderView

-(void)configHeaderView
{
    UIImageView *imageView1 = [[UIImageView alloc] init];
    [imageView1 setImage:[UIImage imageNamed:@"pic1.png"]];
    [_scrollView addSubview:imageView1];

    UIImageView *imageView2 = [[UIImageView alloc] init];
    [imageView2 setImage:[UIImage imageNamed:@"pic2.png"]];
    [_scrollView addSubview:imageView2];
    
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScreenWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [_scrollView setContentSize:(CGSize){ScreenWidth *2, 1}];

}

-(int)getHeaderViewHeight
{
    return 150;
}

@end
