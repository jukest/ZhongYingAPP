//
//  MovieTimesView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MovieTimesViewDelegate <NSObject>

- (void)gotoMovieTimesViewEventIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index;

@end
@interface MovieTimesView : UIView

@property(nonatomic,strong) UITableView *movieTimesTableView;
@property(nonatomic,weak) id<MovieTimesViewDelegate> delegate;
@property(nonatomic,strong) NSArray *todaySchedule;  //!<< 今天时间表
@property(nonatomic,strong) NSArray *afterSchedule;  //!<< 后天时间表
@property(nonatomic,strong) NSArray *tomorrowSchedule;  //!<< 明天时间表

- (instancetype)initWithFrame:(CGRect)frame WithTodayArr:(NSArray *)today tomorrowArr:(NSArray *)tomorrow after:(NSArray *)after;

- (void)show;

- (void)hiddenView;

@end