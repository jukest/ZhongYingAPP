//
//  CinemaDtlHeaderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaDtlHeaderView.h"

@implementation CinemaDtlHeaderView


/**
 CinemaDtlHeaderView

 @param frame     视图大小
 @param CinemaMsg 影院信息
 @param filmsArr  电影信息
 @param index     当前电影下标

 @return CinemaDtlHeaderView
 */
- (instancetype)initWithFrame:(CGRect)frame CinemaMsg:(Cinema *)CinemaMsg filmsArr:(NSArray *)filmsArr index:(NSInteger)index
{
    if (self = [super initWithFrame:frame]) {
        self.cinemaMsgView = [[CinemaMsgView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 66) CinemaMsg:CinemaMsg];
        [self addSubview:self.cinemaMsgView];
        
        self.movieSliderView = [[MoviesSliderView alloc] initWithFrame:CGRectMake(0, 66, ScreenWidth, 205) picArr:filmsArr index:index];
        [self addSubview:self.movieSliderView];
        
    }
    return self;
}


@end
