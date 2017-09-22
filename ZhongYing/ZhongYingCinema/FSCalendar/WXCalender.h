//
//  WXCalender.h
//  日历
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCalender : NSObject

+ (instancetype)shareCalender;


/**
 获取 date 对应的 农历

 @param date 需要转换的 date
 @return 返回的农历
 */
- (NSString *)calendarIdentifierChineseWithDate:(NSDate *)date;


/**
 计算总共有多少个月

 @param dateStr 字符串时间
 @return 返回的 年(无符号整型)
 */
//- (NSUInteger)getCurrentYearWith:(NSString *)dateStr;


/**
 获取当前月份的天数

 @return 返回天数
 */
- (NSInteger)getCurrentMonthForDays;

/**
 获取指定月份的天数

 @param date 指定的时间
 @return 返回天数
 */
-(NSInteger)getNextNMonthForDays:(NSDate *)date;


/**
 获取某个月 1 号 的NSDate对象

 @param date 指定的某月
 @return 指定的NSDate
 */
-(NSDate *)getAMonthframDate:(NSDate*)date;


/**
 计算某个月的  几 号 是星期几

 @param date 指定的日期
 @return 返回的星期
 */
- (NSString *)getFirstDayWeekForMonth:(NSDate *)date;

/**
 计算某个月的  几 号 是星期几
 
 @param date 指定的日期
 @return 返回的星期
 */
- (NSUInteger )getFirstDayWeekIntergerForMonth:(NSDate *)date;

/**
 获取当前系统的时间

 @return 返回当前系统的字符串时间
 */
-(NSString *)getCurrentTimeWithHourMinSecond:(BOOL)flag;

-(int)getYear;
-(int)getMonth;
-(int)getDay;
-(int)getHour;
-(int)getMinute;
-(int)getSecond;

-(NSInteger)getYearWithDate:(NSDate *)date;
-(NSInteger)getMonthWithDate:(NSDate *)date;
-(NSInteger)getDayWithDate:(NSDate *)date;
-(NSInteger)getHourWithDate:(NSDate *)date;
-(NSInteger)getMinuteWithDate:(NSDate *)date;
-(NSInteger)getSecondWithDate:(NSDate *)date;
/**
 获取 指定时间 到 1970 的时间戳

 @param dateStr 指定字符串时间
 @param formatterStr 时间格式
 @return 返回的时间戳
 */
- (NSTimeInterval )timeIntervalWithDateStr:(NSString *)dateStr dateStrFormatterStr:(NSString *)formatterStr;


/**
 字符串时间 -->  NSDate

 @param dateStr 字符串时间
 @param formatterStr 时间格式
 @return 返回的NSDate
 */
- (NSDate *)dateWithDateStr:(NSString *)dateStr dateStrFormatterStr:(NSString *)formatterStr;



/**
 NSDate --> 字符串时间

 @param date 需要抓换的 NSDate
 @param formatterStr 时间格式
 @return 返回的字符串时间
 */
- (NSString *)dateStrWithDate:(NSDate *)date dateStrFormatterStr:(NSString *)formatterStr;



/**
 获取 当前时间到已过时间的时间差

 @param interval 已过时间的时间戳(从1970开始算)
 @return 返回的时间差
 */
-(NSString *)getStandardTimeInterval:(NSTimeInterval)interval;


/**
 计算连个时间之间相差多少天
 注意:两个时间 date 的格式必须一样，不然会有误差
 @param fromDate 第一个时间
 @param toDate 第二个时间
 @return 返回的天数
 */
- (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
