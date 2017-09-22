//
//  WXTabView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ItemBaseView,WXTabView;
@protocol WXTabViewDelegate <NSObject>

- (void)WXTabViewDidScroll:(WXTabView*)tabView;

- (void)WXTabViewDidEndDecelerating:(WXTabView *)tabView;
@end

@interface WXTabView : UIView

@property (nonatomic, weak) id <WXTabViewDelegate> delegate;
@property (nonatomic, assign) CGPoint offset;
- (instancetype)initWithItemsName:(NSArray *)itemsName withImages:(NSArray *)imges childrenView:(NSArray *)childrenView withTableView:(BOOL)isTableView withHasNavigationBar:(BOOL)hasNavigationBar;
@end
