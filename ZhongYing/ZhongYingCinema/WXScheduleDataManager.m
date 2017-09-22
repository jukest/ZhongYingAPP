//
//  WXScheduleDataManager.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/19.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "WXScheduleDataManager.h"
#import "WXCalender.h"

@implementation WXScheduleDataManager

static WXScheduleDataManager *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareScheduleDataManager {
    return [[self alloc]init];
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (NSString *)showInfoWithDate:(NSDate *)date {

    
    //影片的时间信息
     NSInteger filmYear = [[WXCalender shareCalender] getYearWithDate:date];
     NSInteger fileMonth = [[WXCalender shareCalender] getMonthWithDate:date];
     NSInteger fileDay = [[WXCalender shareCalender] getDayWithDate:date];
//     NSInteger weekDay = [[WXCalender shareCalender] getFirstDayWeekIntergerForMonth:date];
//     NSString  *fileWeekDay = [self weekDayStrWithWeekDay:weekDay];
    
     NSString *info = @"";
    
    NSString *year = [NSString stringWithFormat:@"%ld",(long)filmYear];
    
    NSString *month_1 = [NSString stringWithFormat:@"%ld",(long)fileMonth];
    NSString *month_2 = [NSString stringWithFormat:@"0%ld",(long)fileMonth];
    NSString *month = [NSString stringWithFormat:@"%@",fileMonth > 9?month_1:month_2];
    
    NSString *day_1 = [NSString stringWithFormat:@"%ld",(long)fileDay];
    NSString *day_2 = [NSString stringWithFormat:@"0%ld",(long)fileDay];
    NSString *day = [NSString stringWithFormat:@"%@",fileDay > 9?day_1:day_2];
    
    NSString *fileDateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSString *currentDateStr = [[WXCalender shareCalender] getCurrentTimeWithHourMinSecond:NO];
    
    NSDate *fileDate = [[WXCalender shareCalender] dateWithDateStr:fileDateStr dateStrFormatterStr:@"yyyy-MM-dd"];
    NSDate *curretnDate = [[WXCalender shareCalender] dateWithDateStr:currentDateStr dateStrFormatterStr:@"yyyy-MM-dd"];
    //计算两个时间相差多少天
    NSInteger numberOfDay = [[WXCalender shareCalender] numberOfDaysWithFromDate:curretnDate toDate:fileDate];
    
    if (numberOfDay == 0) {//今天
        info = [NSString stringWithFormat:@"今天%@月%@日",month,day];

    } else if (numberOfDay == 1) {//明天
        info = [NSString stringWithFormat:@"明天%@月%@日",month,day];

    } else if (numberOfDay == 2) {//后天
        info = [NSString stringWithFormat:@"后天%@月%@日",month,day];

    } else {//其他
        info = [NSString stringWithFormat:@"%@月%@日",month,day];

    }
        return info;
}

- (NSString *)weekDayStrWithWeekDay:(NSInteger)weekDay {
    NSArray *weekStr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    return weekStr[weekDay];
}



@end
