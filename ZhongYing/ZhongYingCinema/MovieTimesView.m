//
//  MovieTimesView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieTimesView.h"
#import "MovieTimesTableViewCell.h"
#import "Schedule.h"

@interface MovieTimesView ()<UITableViewDelegate,UITableViewDataSource,MovieTimesTableViewCellDelegate>
{
    NSInteger _index;
    UIView *_lineView;
    UIButton *_maskView;
}
@end
@implementation MovieTimesView

- (instancetype)initWithFrame:(CGRect)frame WithTodayArr:(NSArray *)today tomorrowArr:(NSArray *)tomorrow after:(NSArray *)after
{
    if (self = [super initWithFrame:frame]) {
        _maskView = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) title:nil titleColor:[UIColor blackColor] target:self action:@selector(hiddenView) tag:1000];
        _maskView.backgroundColor = [UIColor blackColor];
        self.todaySchedule = today;
        self.tomorrowSchedule = tomorrow;
        self.afterSchedule = after;
        _index = 0;
        if (self.todaySchedule.count == 0) {
            _index = 1;
            if (self.tomorrowSchedule.count == 0) {
                _index = 2;
            }
        }
        [self addSubview:self.movieTimesTableView];
    }
    return self;
}

#pragma mark - 懒加载
- (UITableView *)movieTimesTableView
{
    if (_movieTimesTableView == nil) {
        _movieTimesTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth -58, self.frame.size.height) style:UITableViewStylePlain target:self];
        [_movieTimesTableView registerClass:[MovieTimesTableViewCell class] forCellReuseIdentifier:@"MovieTimesTableViewCell"];
        _movieTimesTableView.bounces = NO;
        [self addSubview:_movieTimesTableView];
    }
    return _movieTimesTableView;
}

- (void)hiddenView
{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)show
{
    [self animationWithView:self duration:0.3];
    _maskView.alpha= 0;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.65;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow  addSubview:self];
    self.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
}

- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}

- (void)btnDidClicked:(UIButton *)btn
{
    CGFloat height;
    
    if (btn.tag == 38) {
        _index = 0;
        if (self.todaySchedule.count >= 3) {
            height = 241;
        }else{
            height = 40 +67 * self.todaySchedule.count;
        }

    }else if (btn.tag == 39){
        _index = 1;
        if (self.tomorrowSchedule.count >= 3) {
            height = 241;
        }else{
            height = 40 +67 * self.tomorrowSchedule.count;
        }
    }else if (btn.tag == 40){
        _index = 2;
        if (self.afterSchedule.count >= 3) {
            height = 241;
        }else{
            height = 40 +67 * self.afterSchedule.count;
        }
    }

    self.movieTimesTableView.frame = CGRectMake(0, 0, ScreenWidth -58, height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, ScreenWidth -58, height);
    [self.movieTimesTableView reloadData];
}

#pragma mark - MovieTimesTableViewCellDelegate
- (void)gotoSelectedMovieTimeIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(gotoMovieTimesViewEventIndexPath:index:)]) {
        [self.delegate gotoMovieTimesViewEventIndexPath:indexPath index:_index];
    }
    [self hiddenView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *today = [NSString stringWithFormat:@"今天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
    NSString *tomorrow =  [NSString stringWithFormat:@"明天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] +86400] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
    NSString *after =  [NSString stringWithFormat:@"后天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] +86400 * 2] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
    NSMutableArray *dates = [NSMutableArray array];
    if (self.todaySchedule.count != 0) {
        [dates addObject:today];
    }
    if (self.tomorrowSchedule.count != 0) {
        [dates addObject:tomorrow];
    }
    if (self.afterSchedule.count != 0) {
        [dates addObject:after];
    }
    
    UIView *datesView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth -58, 40) backgroundColor:[UIColor whiteColor]];
    UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(0, 39, ScreenWidth -58, 1) backgroundColor:Color(240, 240, 240, 1.0)];
    [datesView addSubview:line];
    for (int i = 0; i < dates.count; i ++) {
        UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(i * (ScreenWidth -58) / 3, 0, (ScreenWidth -58) / 3 -1, 38) title:dates[i] titleColor:Color(199, 0, 0, 1.0) target:self action:@selector(btnDidClicked:) tag:0];
        if ([dates[i] hasPrefix:@"后天"]) {
            btn.tag = 40;
        }
        if ([dates[i] hasPrefix:@"明天"]) {
            btn.tag = 39;
        }
        if ([dates[i] hasPrefix:@"今天"]) {
            btn.tag = 38;
        }
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14 * widthFloat];
        
        if (btn.tag == _index +38) {
            [btn setTitleColor:Color(199, 0, 0, 1.0) forState:UIControlStateNormal];
            _lineView = [FanShuToolClass createViewWithFrame:CGRectMake(i * (ScreenWidth -58) / 3, 38, (ScreenWidth -58) / 3 -1, 2) backgroundColor:Color(201, 0, 0, 1.0)];
            [datesView addSubview:_lineView];
        }else {
            [btn setTitleColor:Color(120, 120, 120, 1.0) forState:UIControlStateNormal];
        }
        [datesView addSubview:btn];
    }
    return datesView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_index == 0) {
        return self.todaySchedule.count;
    }else if (_index == 1){
        return self.tomorrowSchedule.count;
    }else{
        return self.afterSchedule.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTimesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTimesTableViewCell"];
    cell.indexPath = indexPath;
    Schedule *schedule;
    if (_index == 0) {
        schedule = self.todaySchedule[indexPath.row];
    }else if (_index == 1){
        schedule = self.tomorrowSchedule[indexPath.row];
    }else{
        schedule = self.afterSchedule[indexPath.row];
    }
    [cell configCellWithModel:schedule];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

@end
