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
#import "WXSegmentView.h"
#import "WXScheduleDataManager.h"
#import "CBSegmentView.h"

@interface MovieTimesView ()<UITableViewDelegate,UITableViewDataSource,MovieTimesTableViewCellDelegate>
{
    NSInteger _index;
    UIView *_lineView;
    UIButton *_maskView;
}

@property (nonatomic, strong) NSArray *playPlans;


@property (nonatomic, strong) WXSegmentView *sliderSegmentView;

/**
 安排的日期数组
 */
@property (nonatomic, strong) NSMutableArray *playDates;

@property (nonatomic, assign) NSInteger selectedPlayDateIndex;
@end
@implementation MovieTimesView


- (WXSegmentView *)sliderSegmentView {
    if (!_sliderSegmentView) {
        __weak typeof(self) weakSelf = self;
        _sliderSegmentView = [[WXSegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-58, 40)];
        [_sliderSegmentView setTitleArray:self.playDates withStyle:WXSegmentStyleSlider];
        _sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
            weakSelf.selectedPlayDateIndex = x;
            [weakSelf.movieTimesTableView reloadData];
        };
    }
    return _sliderSegmentView;
}


- (instancetype)initWithFrame:(CGRect)frame withFilmPlayPlans:(NSArray *)filmPlayPlans {
    self  = [super initWithFrame:frame];
    if (self) {
        _maskView = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) title:nil titleColor:[UIColor blackColor] target:self action:@selector(hiddenView) tag:1000];
        _maskView.backgroundColor = [UIColor blackColor];
        self.playPlans = filmPlayPlans;
        self.selectedPlayDateIndex = 0;
        [self numberOfTotalDayForFilms];
        [self addSubview:self.movieTimesTableView];
        
    }
    return self;
}

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
- (NSMutableArray *)playDates {
    if (!_playDates) {
        _playDates = [[NSMutableArray alloc]init];
    }
    return _playDates;
}
- (UITableView *)movieTimesTableView
{
    if (_movieTimesTableView == nil) {
        _movieTimesTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth -40, self.frame.size.height) style:UITableViewStylePlain target:self];
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



#pragma mark - MovieTimesTableViewCellDelegate
- (void)gotoSelectedMovieTimeIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(gotoMovieTimesViewEventIndexPath:index:)]) {
        [self.delegate gotoMovieTimesViewEventIndexPath:indexPath index:_index];
    }
    if ([self.delegate respondsToSelector:@selector(gotoMovieTimesViewEventIndexPath:withSchedule:)]) {
        NSArray *schedules = [self schedulesWithSelectedPlayDateIndex:self.selectedPlayDateIndex];
        [self.delegate gotoMovieTimesViewEventIndexPath:indexPath withSchedule:schedules[indexPath.row]];
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

    return self.sliderSegmentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_index == 0) {
//        return self.todaySchedule.count;
//    }else if (_index == 1){
//        return self.tomorrowSchedule.count;
//    }else{
//        return self.afterSchedule.count;
//    }
    
    return [self schedulesWithSelectedPlayDateIndex:self.selectedPlayDateIndex].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTimesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTimesTableViewCell"];
    cell.indexPath = indexPath;
    Schedule *schedule = (Schedule *)[self schedulesWithSelectedPlayDateIndex:self.selectedPlayDateIndex][indexPath.row];

    [cell configCellWithModel:schedule];
    cell.serviceMoney = self.serviceMoney;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}


#pragma mark --对排片计划模型数组进行处理

//计算 总共售卖 多少天
- (NSInteger)numberOfTotalDayForFilms {
    
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithCapacity:self.playPlans.count];
    for (Schedule *schedule in self.playPlans) {
        [resultDict setObject:@(schedule.date) forKey:@(schedule.date)];
    }
    NSArray *resultArray = resultDict.allValues;
    
    //排序
    resultArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    //获取模型
    NSMutableArray *resultModels = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < resultArray.count; i++) {
        
        NSInteger startTime = [resultArray[i] integerValue];
        for (int j = 0; j<self.playPlans.count; j++) {
            Schedule *schedule = self.playPlans[j];
            if (schedule.date == startTime) {
                [resultModels addObject:schedule];
            }
        }
    }
    
    [self.playDates removeAllObjects];
    
    for (int i = 0; i < resultModels.count; i++) {
        Schedule *schedule = resultModels[i];
        
        [self.playDates addObject:[[WXScheduleDataManager shareScheduleDataManager] showInfoWithDate:[NSDate dateWithTimeIntervalSince1970:schedule.start_time]]];
    }
    //去重
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *string in self.playDates) {
        if (![result containsObject:string]) {
            [result addObject:string];
        }
    }
    self.playDates = result;
    NSLog(@"%@",self.playDates);

    
    return self.playDates.count;

}

- (NSArray *)schedulesWithSelectedPlayDateIndex:(NSInteger)selectedIndex {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.playPlans.count; i++) {
        Schedule *schedule = self.playPlans[i];
        
        if ([self.playDates[selectedIndex] isEqualToString:schedule.showInfo]) {
            [array addObject:schedule];
        }
        
    }
    
    
    return array;
}


@end
