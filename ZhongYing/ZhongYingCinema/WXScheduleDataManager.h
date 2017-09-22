//
//  WXScheduleDataManager.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/19.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXScheduleDataManager : NSObject
+ (instancetype)shareScheduleDataManager;
- (NSString *)showInfoWithDate:(NSDate *)date;
//- (NSString *)showInfoWithTimeInterval:(NSTimeInterval )timeInterval;
@end
