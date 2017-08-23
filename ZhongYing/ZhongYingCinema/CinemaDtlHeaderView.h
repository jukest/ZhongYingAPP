//
//  CinemaDtlHeaderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaMsgView.h"
#import "MoviesSliderView.h"
#import "Cinema.h"

@interface CinemaDtlHeaderView : UIView

@property(nonatomic,strong) CinemaMsgView *cinemaMsgView;
@property(nonatomic,strong) MoviesSliderView *movieSliderView;
//@property(nonatomic,strong) MovieLayoutView *movieLayoutView;

- (instancetype)initWithFrame:(CGRect)frame CinemaMsg:(Cinema *)CinemaMsg filmsArr:(NSArray *)filmsArr index:(NSInteger)index;

@end
