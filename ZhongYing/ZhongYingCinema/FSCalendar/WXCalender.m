//
//  WXCalender.m
//  日历
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WXCalender.h"


@interface WXCalender ()
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSCalendar *currentCalendar;
@property (nonatomic, strong) NSCalendar *chineseCalendar;
@property (nonatomic, strong) NSCalendar *gregorianCalendar;

@end

@implementation WXCalender

- (NSCalendar *)gregorianCalendar {
    if (!_gregorianCalendar) {
        _gregorianCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorianCalendar;
}

- (NSCalendar *)currentCalendar {
    if (!_currentCalendar) {
        _currentCalendar = [NSCalendar currentCalendar];
    }
    return _currentCalendar;
}

- (NSCalendar *)chineseCalendar{
    if (!_chineseCalendar) {
        _chineseCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    }
    return _chineseCalendar;
}

#pragma mark -- 单例
static WXCalender *_instance;
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

+ (instancetype)shareCalender {
    return [[self alloc]init];
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark --与农历相关
- (NSString *)calendarIdentifierChineseWithDate:(NSDate *)date {
    NSString *chineseDateStr = @"";
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *com = [self.chineseCalendar components:unit fromDate:date];
    
    NSInteger day = com.day;
    NSInteger month = com.month;
    NSInteger year = com.year;
    
    chineseDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    
    
    return chineseDateStr;
    
}


#pragma mark -- 与NSCalendar相关
// 获取当前月份的天数
- (NSInteger)getCurrentMonthForDays {
    NSInteger dayNumber = 0;
    
    NSRange range = [self.currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    
    dayNumber = range.length;
    
    return dayNumber;
}


// 获取目标月份的天数
-(NSInteger)getNextNMonthForDays:(NSDate *)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // 调用rangeOfUnit方法:(返回一样是一个结构体)两个参数一个大单位，一个小单位(.length就是天数，.location就是月)
    NSInteger monthNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    return monthNum;
}

// 获取某个月的1号的 date 对象
-(NSDate *)getAMonthframDate:(NSDate*)date {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    // 指定日历单位，如日期和月份。(这里指定了年月日，还有其他字段添加单位.特别齐全 ：世纪，年月日时分秒等等等)
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // NSDateComponents封装了日期的组件,年月日时分秒等(个人感觉像是平时用的model模型)
    NSDateComponents *components = [calendar components: dayInfoUnits fromDate:date];
    // 指定1号
    components.day = 1;

    // 转成需要的date对象return
    NSDate * nextMonthDate =[calendar dateFromComponents:components];
    return nextMonthDate;
}

// 获取某个月的1号是星期几
- (NSString *)getFirstDayWeekForMonth:(NSDate *)date {
    NSInteger weekDay = 0;
    NSArray *weekStr = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    //获取公历日历
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    weekDay = components.weekday;
    
#warning mark --找了很多原因不知道为什么星期数总是比实际快一天,有时间找更好的解决方法（暂时用-1天处理了）
    weekDay--;
    
    return weekStr[weekDay];
    
    
}

// 获取某个月的1号是星期几
- (NSUInteger )getFirstDayWeekIntergerForMonth:(NSDate *)date{
    NSUInteger weekDay = 0;
//    NSArray *weekStr = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    //获取公历日历
    NSCalendar *calendar = self.gregorianCalendar;
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    weekDay = components.weekday;
    
    weekDay--;
    
    return weekDay;

}


#pragma mark -- 与时间NSDate相关
-(NSString *)getCurrentTimeWithHourMinSecond:(BOOL)flag{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    // 格式化系统时间字符串</code>
    if (flag) {
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];

    }
    NSString * time = [formatter stringFromDate:[NSDate date]];
    return time;
}

-(int)getYear{
    NSCalendar *calendar = self.currentCalendar;
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return (int)dateComponent.year;
    
}
-(int)getMonth{
    NSCalendar *calendar = self.currentCalendar;
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return (int)dateComponent.month;
}
-(int)getDay{
    NSCalendar *calendar = self.currentCalendar;
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return (int)dateComponent.day;
}
-(int)getHour{
    NSCalendar *calendar = self.currentCalendar;
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return (int)dateComponent.hour;
}
-(int)getMinute{
    NSCalendar *calendar = self.currentCalendar;
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return (int)dateComponent.minute;
}
-(int)getSecond{
    NSCalendar *calendar = self.currentCalendar;
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return (int)dateComponent.second;
}
-(NSInteger)getYearWithDate:(NSDate *)date{
    NSCalendar *calendar = self.gregorianCalendar;
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];

    return components.year;
    
}
-(NSInteger)getMonthWithDate:(NSDate *)date{
    NSCalendar *calendar = self.gregorianCalendar;
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    
    return components.month;
}
-(NSInteger)getDayWithDate:(NSDate *)date{
    NSCalendar *calendar = self.gregorianCalendar;
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    
    return components.day;
}
-(NSInteger)getHourWithDate:(NSDate *)date{
    NSCalendar *calendar = self.gregorianCalendar;
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    
    return components.hour;
}
-(NSInteger)getMinuteWithDate:(NSDate *)date{
    NSCalendar *calendar = self.gregorianCalendar;
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    
    return components.minute;
}
-(NSInteger)getSecondWithDate:(NSDate *)date{
    NSCalendar *calendar = self.gregorianCalendar;
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    return components.second;
}



- (NSTimeInterval )timeIntervalWithDateStr:(NSString *)dateStr dateStrFormatterStr:(NSString *)formatterStr {
    NSDate *date = [self dateWithDateStr:dateStr dateStrFormatterStr:formatterStr];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}

// 字符串时间 -->  NSDate
- (NSDate *)dateWithDateStr:(NSString *)dateStr dateStrFormatterStr:(NSString *)formatterStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterStr];
    NSDate *date = [formatter dateFromString:dateStr];
    
    return date;
    
}

// NSDate --> 字符串时间
- (NSString *)dateStrWithDate:(NSDate *)date dateStrFormatterStr:(NSString *)formatterStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterStr];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

// 当前时间与指定时间的间隔
-(NSString *)getStandardTimeInterval:(NSTimeInterval)interval{

    //当前时间与1970时间戳(秒为单位)
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    // 当前时间戳-传入的时间戳=差值(比如朋友圈动态发表时间为10分钟前(当前时间-发表时间))
    NSTimeInterval timeInterval = time-interval;
    //计算出天、小时、分钟
    int day = timeInterval/(60*60*24);
    int hour = ((long)timeInterval%(60*60*24))/(60*60);
    int minite = ((long)timeInterval%(60*60*24))%(60*60)/60;
    NSMutableString * timeStr = [[NSMutableString alloc]init];
    // 逻辑判断
    if (day!=0) {
        [timeStr appendString:[NSString stringWithFormat:@"%d天",day]];
    }else{
        if (hour!=0) {
            [timeStr appendString:[NSString stringWithFormat:@"%d小时",hour]];
        }else{
            if (minite<1) {
                [timeStr appendString:@"刚刚"];
            }else{
                [timeStr appendString:[NSString stringWithFormat:@"%d分钟",minite]];
            }
        }
    }
    return timeStr;
}

- (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
       NSCalendar *calendar = self.gregorianCalendar;
  
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    
       return comp.day;
   }


@end
