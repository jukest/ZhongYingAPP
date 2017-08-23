//
//  NSString+Commen.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/12/10.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Commen)

// 是否是手机号码
- (BOOL)isMobile;
// 密码限制6-20位
- (BOOL)createPasswordByLimit;
// 时间戳转换成yyyy//MM//dd
- (NSString *)transforTomyyyyMMddWithFormatter:(NSString *)format;
// 时间戳转化成星期
+ (NSString *)getWeekDayFordate:(long long)data;

@end
