//
//  NSString+Commen.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/12/10.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "NSString+Commen.h"

@implementation NSString (Commen)

// 是否是手机号码
- (BOOL)isMobile{
    NSString *mobileRegex = @"[1][3578]\\d{9}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:self];
}

// 密码限制6-20位
- (BOOL)createPasswordByLimit{
    NSString *password = @"^[0-9A-Za-z]{6,20}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password];
    return [passwordTest evaluateWithObject:self];
}

// 时间戳转换成format (e.g: yyyy//MM//dd)
- (NSString *)transforTomyyyyMMddWithFormatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    return [formatter stringFromDate:d];
}

+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

@end
