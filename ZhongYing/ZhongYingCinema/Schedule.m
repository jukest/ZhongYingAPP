//
//  Schedule.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "Schedule.h"
#import "WXCalender.h"
#import "WXScheduleDataManager.h"

@implementation Schedule

+ (NSMutableArray *)wx_objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray {
    
    NSMutableArray *models = [Schedule mj_objectArrayWithKeyValuesArray:keyValuesArray];
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithCapacity:models.count];
    for (Schedule *schedule in models) {
        [resultDict setObject:@(schedule.start_time) forKey:@(schedule.start_time)];//NSNumericSearch
    }
    NSArray *resultArray = resultDict.allValues;
    
    resultArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];

    NSMutableArray *resultModels = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < resultArray.count; i++) {
        
        NSInteger startTime = [resultArray[i] integerValue];
        for (int j = 0; j<models.count; j++) {
            Schedule *schedule = models[j];
            if (schedule.start_time == startTime) {
                [resultModels addObject:schedule];
            }
        }
    }
    
    
    for (int i = 0 ; i < resultModels.count; i++) {
        
        Schedule *scedule = (Schedule *)resultModels[i];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:scedule.start_time];
        
        scedule.year = [[WXCalender shareCalender] getYearWithDate:date];
        scedule.month = [[WXCalender shareCalender] getMonthWithDate:date];
        scedule.day = [[WXCalender shareCalender] getDayWithDate:date];
        scedule.hour = [[WXCalender shareCalender] getHourWithDate:date];;
        scedule.min = [[WXCalender shareCalender] getMinuteWithDate:date];;
        
        scedule.weekDay = [[WXCalender shareCalender] getFirstDayWeekIntergerForMonth:date];
        
        scedule.showInfo = [[WXScheduleDataManager shareScheduleDataManager] showInfoWithDate:date];
        
        NSString *year = [NSString stringWithFormat:@"%d",scedule.year];
        
        NSString *month_1 = [NSString stringWithFormat:@"%d",scedule.month];
        NSString *month_2 = [NSString stringWithFormat:@"0%d",scedule.month];
        NSString *month = [NSString stringWithFormat:@"%@",scedule.month > 9?month_1:month_2];
        
        NSString *day_1 = [NSString stringWithFormat:@"%d",scedule.day];
        NSString *day_2 = [NSString stringWithFormat:@"0%d",scedule.day];
        NSString *day = [NSString stringWithFormat:@"%@",scedule.day > 9?day_1:day_2];
        
        scedule.date = [[NSString stringWithFormat:@"%@%@%@",year,month,day] integerValue];
        
    }
    
    return resultModels;

}

- (NSString *)weekDayStrWithWeekDay:(NSInteger)weekDay {
    NSArray *weekStr = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    return weekStr[weekDay];
}





@end
