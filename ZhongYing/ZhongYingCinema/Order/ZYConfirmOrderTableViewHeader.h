//
//  ZYConfirmOrderTableViewHeader.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYConfirmOrderTableViewHeader : UIView

- (void)setUpFilmInfo:(NSDictionary *)filmDic withCinema_name:(NSString *)cinema_name withSelectSeat:(NSArray *)seats;
- (void)timerCutWithTime:(NSInteger)time;

@end
