//
//  XunStickyHeaderScrollViewController.m
//  JuHui
//
//  Created by yanglixun on 16/1/17.
//  Copyright © 2016年 Caibo-Inc. All rights reserved.
//

#import "XunStickyHeaderScrollViewController.h"
#import <Masonry/Masonry.h>

#define DefaultHeaderViewHeight 200
#define DefaultNavBarViewHeight 40


#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#define TopViewHidden 1
#define TopViewShown 2

@interface XunStickyHeaderScrollViewController ()
{
    NSInteger _currentSelectedIndex;
    UIViewController *_currentSelectedViewController;
    
    __strong UIView *_topView;
    __strong UIView *_stickyView;
    
}
@end

@implementation XunStickyHeaderScrollViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // MEMO:
    // An inherited class does not load xib file.
    self = [super initWithNibName:@"XunStickyHeaderScrollViewController" bundle:nibBundleOrNil];
    if (self) {
        self.headerHeight = DefaultHeaderViewHeight;
        self.navBarHeight = DefaultNavBarViewHeight;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = [self getScreenEdgePanGestureRecognizer:self.navigationController];
    if(screenEdgePanGestureRecognizer){
        [_mainContainer.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
    }
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [_mainContainer addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setHeaderView:(UIView *)headerView navBar:(UIView *)navBar selectedBlock:(XunStickyHeaderScrollViewControllerBlock)selectedBlock
{
    if(selectedBlock){
        _sticyHeaderDidSelectedBlock = selectedBlock;
    }
    
    if(_headerView!=headerView){
    
        [_headerView removeFromSuperview];
        _headerView = headerView;
        
    }
    
    if(_navBar!=navBar){
        [_navBar removeFromSuperview];
        _navBar = navBar;
    }
    
    if(!_topView){
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _headerHeight+_navBarHeight)];
        [self.view addSubview:_topView];
        [_topView setHidden:YES];
        [_topView setTag:TopViewHidden];
    }
    
    
    
    if(!_stickyView){
        _stickyView = [[UIView alloc] initWithFrame:(CGRect){0,0,ScreenWidth,self.headerHeight+self.navBarHeight}];
        
        
        [_stickyView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.headerHeight);
        }];
        
        [_stickyView addSubview:_navBar];
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.navBarHeight);
        }];
    }
    
}


-(void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
    if(_headerView){
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(headerHeight);
        }];
    }
    
}

-(void)setNavBarHeight:(CGFloat)navBarHeight
{
    _navBarHeight = navBarHeight;
    
    if(_navBar){
        [_navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(navBarHeight);
        }];
    }
}

-(void)selectCurrentViewControllerAtIndex:(NSInteger)index
{
    if(_viewControllers && [_viewControllers count]>index && (int)_mainContainer.contentOffset.x%(int)ScreenWidth==0){
        [_mainContainer setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
    }
}


-(void)setViewControllers:(NSArray *)viewControllers
{
    if ([_viewControllers isEqualToArray:viewControllers] == NO) {
        
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            UIScrollView *scrollView = [self scrollViewWithSubViewController:viewController];
            if (scrollView) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            }
            
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
            
        }];
        
        // Assign new view controllers
        _viewControllers = [viewControllers copy];
        
        
        _currentSelectedIndex = 0;
        _currentSelectedViewController = [_viewControllers objectAtIndex:0];
        
        
        [[self scrollViewWithSubViewController:_currentSelectedViewController]  setTableHeaderView:_stickyView];
        
        
        // Add views in new view controllers
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            
            
            UIView *subView = viewController.view;
            [_mainContainer addSubview:subView];
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(ScreenWidth);
                make.height.equalTo(_mainContainer);
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(ScreenWidth*idx);
            }];
            
            
            UITableView *tableView = [self scrollViewWithSubViewController:viewController];
            
            if(viewController!=_currentSelectedViewController){
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.headerHeight+self.navBarHeight)];
                [tableView setTableHeaderView:view];
            }
            
            
            if (tableView) {
                [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            }
            [self addChildViewController:viewController];
            
        }];
        
        if(self.sticyHeaderDidSelectedBlock){
            self.sticyHeaderDidSelectedBlock(self, _currentSelectedIndex, _currentSelectedViewController);
        }
        
        [_mainContainer setContentSize:CGSizeMake(ScreenWidth*[_viewControllers count], 1)];
        
        [_mainContainer setDelegate:self];
        
    }
    
}


-(void)dealloc{
    
    [_mainContainer removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        
        if(_mainContainer==object){
            
            CGFloat offsetX = [change[@"new"] CGPointValue].x;
            if((int)offsetX%(int)ScreenWidth==0)return;
            
            int index =  (offsetX+ScreenWidth/2)/ScreenWidth;
            
            if(_currentSelectedIndex!=index){
                _currentSelectedIndex = index;
                _currentSelectedViewController = [_viewControllers objectAtIndex:index];
                
                if(self.sticyHeaderDidSelectedBlock){
                    self.sticyHeaderDidSelectedBlock(self, index, _currentSelectedViewController);
                }
            }
            
            UITableView *tableView = [self scrollViewWithSubViewController:_currentSelectedViewController] ;
            if(_topView.tag==TopViewHidden){
                
                [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                    
                    [[self scrollViewWithSubViewController:viewController] setTableHeaderView:[self blankEqualHeaderHeightView]];
                    
                    if(viewController!=_currentSelectedViewController){
                        
                        //计算偏移量
                        if(tableView.contentOffset.y>=_headerHeight){
                            
                            if([self scrollViewWithSubViewController:viewController] .contentOffset.y<_headerHeight){
                                
                                [[self scrollViewWithSubViewController:viewController]  setContentOffset:(CGPoint){0, _headerHeight}];
                            }
                            
                            
                        }else{
                            
                            [[self scrollViewWithSubViewController:viewController]  setContentOffset:(CGPoint){0, tableView.contentOffset.y}];
                        }
                    }
                    
                }];
            }
            
            if(tableView.contentOffset.y<_headerHeight){
                
                [tableView setTableHeaderView:[self blankEqualHeaderHeightView]];
                
                if(_topView.isHidden){
                    [_topView addSubview:_stickyView];
                    [_topView setHidden:NO];
                    [_topView setTag:TopViewShown];
                    [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.mas_equalTo(-tableView.contentOffset.y);
                        make.left.right.mas_equalTo(0);
                        make.height.mas_equalTo(_headerHeight+_navBarHeight);
                        
                    }];
                }
            }
        }else if([self scrollViewWithSubViewController:_currentSelectedViewController]==object){
        
            CGFloat offsetY = [change[@"new"] CGPointValue].y;
            
            if(offsetY>=self.headerHeight){
                if(_topView.isHidden){
                    
                    [[self scrollViewWithSubViewController:_currentSelectedViewController]  setTableHeaderView:[self blankEqualHeaderHeightView]];
                    
                    [_topView addSubview:_stickyView];
                    [_topView setHidden:NO];
                    [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.mas_equalTo(-_headerHeight);
                        make.left.right.mas_equalTo(0);
                        make.height.mas_equalTo(_headerHeight+_navBarHeight);
                        
                    }];
                }
            
            }else if(!_topView.isHidden){
                    
                [_stickyView removeFromSuperview];
                
                [[self scrollViewWithSubViewController:_currentSelectedViewController] setTableHeaderView:_stickyView];
                [_topView setHidden:YES];
                
            }
            
            
            
        }
        
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if(!decelerate){
        [self scrollViewDidEndScrolling:scrollView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrolling:scrollView];
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrolling:scrollView];
}


-(void)scrollViewDidEndScrolling:(UIScrollView *)scrollView
{
    if(_topView && _topView.tag==TopViewShown){
        
        [_stickyView removeFromSuperview];
        
        [[self scrollViewWithSubViewController:_currentSelectedViewController] setTableHeaderView:_stickyView];
        [_topView setHidden:YES];
        [_topView setTag:TopViewHidden];
    }
}




-(UITableView *)scrollViewWithSubViewController:(UIViewController *)viewController
{
    if ([viewController.view isKindOfClass:[UITableView class]]) {
        return (id)viewController.view;
    } else {
        
        NSArray *subViews = viewController.view.subviews;
        for(UIView *view in subViews){
            if ([view isKindOfClass:[UITableView class]]) {
                return (id)view;
            }
        }
        return nil;
    }
}



-(UIView *)blankEqualHeaderHeightView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _headerHeight+_navBarHeight)];
    return view;
}



-(UIScreenEdgePanGestureRecognizer *)getScreenEdgePanGestureRecognizer:(UINavigationController *)nc
{
    if(nc==nil)return nil;
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    for (UIGestureRecognizer *recognizer in nc.view.gestureRecognizers)
    {
        if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
        {
            screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
            break;
        }
    }
    return screenEdgePanGestureRecognizer;
}

@end
