//
//  ZYInformationBoxOfficeView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationBoxOfficeView.h"
#import "BoxOfficeHeaderView.h"
#import "ZYInformationBoxOfficeHeaderView.h"
#include "ZYInformationBoxOfficeTableViewSectionHeader.h"

//日历
#import "FullScreenExampleViewController.h"

@interface ZYInformationBoxOfficeView()<ZYInformationBoxOfficeHeaderViewDelegate,ZYInformationBoxOfficeTableViewSectionHeaderDelegate>
/** 头部视图 */
@property (nonatomic, strong) ZYInformationBoxOfficeHeaderView *header;

/** sectionHeaderView */
@property (nonatomic, strong) ZYInformationBoxOfficeTableViewSectionHeader *sectionHeaderView;

@end

@implementation ZYInformationBoxOfficeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBoxOfficeData:) name:ZYInformationUpdataBoxOfficeNotification object:nil];
        
        
    }
    return self;
}

#pragma mark -- ZYInformationUpdataBoxOfficeNotification

- (void)updataBoxOfficeData:(NSNotification *)noti {
    
    [self endRefresh];
    self.header = [[ZYInformationBoxOfficeHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ZYInformationBoxOfficeHeaderViewCalendarViewHeigth + ZYInformationBoxOfficeHeaderViewBoxOfficeViewHeigth)];
    self.header.delegate = self;
    self.header.currentBoxOffice = @"0";
    self.tableView.tableHeaderView = self.header;
    
    [self.tableView reloadData];
    
    if (self.tableView.mj_footer == nil) {
        
        [self addRefreshView];
    }
}


- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.tableView reloadData];
        
        //发送通知 加载 更多数据
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYInformationUpdataMoreBoxOfficeNotification object:nil];
    }];
    
}

- (void)endRefresh {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ZYInformantionMainNetworingRequst shareInstance].boxOfficesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *whiteView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 10) backgroundColor:[UIColor whiteColor]];
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 80) backgroundColor:[UIColor whiteColor]];
    
    ZYInformationBoxOfficeTableViewSectionHeader *sectionHeaderView = [[ZYInformationBoxOfficeTableViewSectionHeader alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 60)];
    self.sectionHeaderView = sectionHeaderView;
    sectionHeaderView.delegate = self;
    [view addSubview:whiteView];
    [view addSubview:sectionHeaderView];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYInformationBoxOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZYInformationBoxOfficeCell" forIndexPath:indexPath];
//    [cell configCellWithModel:[ZYInformantionMainNetworingRequst shareInstance].boxOfficesArray[indexPath.row]];
    cell.boxOffice = [ZYInformantionMainNetworingRequst shareInstance].boxOfficesArray[indexPath.row];
    if ((indexPath.row % 2) == 0) {
        cell.backgroundColor = [UIColor whiteColor];

    } else {
        cell.backgroundColor = Color(239, 239, 239, 1);

    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- ZYInformationBoxOfficeHeaderViewDelegate
- (void)informationBoxOfficeHeaderView:(ZYInformationBoxOfficeHeaderView *)header buttonDidAction:(ZYInformationBoxOfficeHeaderViewBtnEvent)eventType {
    switch (eventType) {
        case ZYInformationBoxOfficeHeaderViewBtnEventAgoDay:
        {
            NSLog(@"前一天");
            
            self.header.currentDate = [self calculateMonthDay:NO withCurrentDateStr:self.header.currentDate];
            self.header.weekDay = [self calculateWeekDayWithCurrentDate:self.header.currentDate];
            
            break;
        }
        case ZYInformationBoxOfficeHeaderViewBtnEventLaterDay:
        {
            NSLog(@"后一天");

            self.header.currentDate = [self calculateMonthDay:YES withCurrentDateStr:self.header.currentDate];
            self.header.weekDay = [self calculateWeekDayWithCurrentDate:self.header.currentDate];

            break;
        }
        case ZYInformationBoxOfficeHeaderViewBtnEventCalendar:
        {
            __weak typeof(self) weakSelf = self;
            NSLog(@"选择日期");
            FullScreenExampleViewController *calenderVC = [[FullScreenExampleViewController alloc]init];
            calenderVC.selectedCalenderBlock = ^(FSCalendar *calender, NSDate *date, NSString *dateStr) {
                weakSelf.header.currentDate = dateStr;
                
                weakSelf.header.weekDay = [self calculateWeekDayWithCurrentDate:weakSelf.header.currentDate];

            };
            UIViewController *vc = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
            [calenderVC setHidesBottomBarWhenPushed:YES];
            [vc.navigationController pushViewController:calenderVC animated:YES];

            break;
        }
            default:
            NSLog(@"");
            break;
    }
    
    
}
#pragma mark -- ZYInformationBoxOfficeTableViewSectionHeaderDelegate
- (void)informationBoxOfficeTableViewSectionHeader:(ZYInformationBoxOfficeTableViewSectionHeader *)sectionHeaderView buttonDidClick:(UIButton *)button {
    NSLog(@"更多指标");
}


#pragma mark -- 获取当前控制器
// 获取当前VC
- (UIViewController *)topVC:(UIViewController *)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navc = (UINavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}


/**
 计算当前日期的前一天或者后一天

 @param later 是否计算后一天
 @param currentDateStr 当期的日期
 @return 返回计算后的字符串
 */
- (NSString *)calculateMonthDay:(BOOL)later withCurrentDateStr:(NSString *)currentDateStr {
    NSInteger second = 0;
    if (later) {//后一天
        second = 24*60*60;
    } else {
        second = - 24* 60 * 60;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *inputDate = [inputFormatter dateFromString:currentDateStr];
    NSDate *nextDate = [NSDate dateWithTimeInterval:second sinceDate:inputDate];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday|NSCalendarUnitDay fromDate:nextDate];
    
    NSString *month = comps.month > 9 ? [NSString stringWithFormat:@"%ld",(long)comps.month]:[NSString stringWithFormat:@"0%ld",(long)comps.month];
    NSString *day = comps.day > 9 ?[NSString stringWithFormat:@"%ld",(long)comps.day]:[NSString stringWithFormat:@"0%ld",(long)comps.day];
    NSString *currentDate = [NSString stringWithFormat:@"%ld-%@-%@",(long)comps.year,month,day];
    return currentDate;
}

- (NSString *)calculateWeekDayWithCurrentDate:(NSString *)currentDateStr {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil, nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *inputDate = [inputFormatter dateFromString:currentDateStr];
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end
