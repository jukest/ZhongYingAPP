//
//  ZYMallViewController.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"


@class ZYMallViewController;

@protocol ZYMallViewControllerScrollViewDelegate <NSObject>

@optional
- (void)mallViewController:(ZYMallViewController*)mallViewController scrollViewDidScroll:(UIScrollView *)scrollView withIndex:(NSInteger)index;

- (void)mallViewController:(ZYMallViewController*)mallViewController scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView withIndex:(NSInteger)index;

- (void)mallViewController:(ZYMallViewController*)mallViewController scrollViewDidEndDecelerating:(UIScrollView *)scrollView withIndex:(NSInteger)index;


@end


@interface ZYMallViewController : ZYViewController
@property (nonatomic, weak) id <ZYMallViewControllerScrollViewDelegate> scrollViewDelegate;
@end
