//
//  UIViewController+Commen.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "UIViewController+Commen.h"
#import <Accelerate/Accelerate.h>

@implementation UIViewController (Commen)

// 创建UIScrollView
+ (UIScrollView *)createScrollView{
    UIScrollView *scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight-58) target:nil];
    scrollView.backgroundColor = [UIColor whiteColor];
    return scrollView;
}

// 创建MBProgressHUD提示
- (void)showHudMessage:(NSString *)message{
    [self show:message];
}

- (void)show:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    /*
     MBProgressHUDModeAnnularDeterminate 有一个圆圈
     MBProgressHUDModeCustomView 正常长方形
     MBProgressHUDModeDeterminate 有一个白色圆圈
     MBProgressHUDModeDeterminateHorizontalBar 有一个长线条
     MBProgressHUDModeIndeterminate 有一个动画菊花效果
     MBProgressHUDModeText 没有动画
     */
    // 有一个圆圈
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.cornerRadius = 3;
    hud.yOffset = ScreenHeight/2-80;
    hud.labelFont = [UIFont systemFontOfSize:15];
    [hud hide:YES afterDelay:1.0f];
}

- (void)hideRefreshViewsubViews:(UITableView *)tableView
{
    [[(MJChiBaoZiHeader *)tableView.mj_header lastUpdatedTimeLabel] setHidden:YES];
    [[(MJChiBaoZiHeader *)tableView.mj_header stateLabel] setHidden:YES];
//    [(MJChiBaoZiFooter2 *)tableView.mj_footer setRefreshingTitleHidden:YES];
    
    [[(MJChiBaoZiFooter2 *)tableView.mj_footer stateLabel] setHidden:YES];
}

+ (NSString *)getTimeStrWithInterval:(NSTimeInterval)interval
{
    NSString *timeStr;
    NSString *str = [NSString stringWithFormat:@"%d",(int)interval];
    if (interval <= 3600) {
        if ((int)interval / 60 == 0) {
            timeStr = @"刚刚";
        }else{
            timeStr = [NSString stringWithFormat:@"%d分钟前",(int)interval / 60];
        }
    }else if (interval > 3600 && interval <= 3600 * 24){
        timeStr = [NSString stringWithFormat:@"%d小时前",(int)interval / 3600];
    }else if (interval > 3600 * 24 && interval <= 3600 * 24 * 2){
        timeStr = @"昨天";
    }else if (interval > 3600 * 24 * 2 && interval <= 3600 * 24 * 3){
        timeStr = @"前天";
    }else{
        NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
        interval = currentInterval - interval;
        str = [NSString stringWithFormat:@"%d",(int)interval];
        timeStr = [str transforTomyyyyMMddWithFormatter:@"MM-dd"];
    }
    return timeStr;
}

@end
