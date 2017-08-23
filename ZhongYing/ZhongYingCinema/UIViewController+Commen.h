//
//  UIViewController+Commen.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Commen)

// 创建UIScrollView
+ (UIScrollView *)createScrollView;
// 创建MBProgressHUD提示
- (void)showHudMessage:(NSString *)message;

- (void)hideRefreshViewsubViews:(UITableView *)tableView;

+ (NSString *)getTimeStrWithInterval:(NSTimeInterval)interval;

@end
