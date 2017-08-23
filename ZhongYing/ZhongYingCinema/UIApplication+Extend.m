//
//  UIApplication+Extend.m
//  OldManWatch
//
//  Created by 小菜皮 on 16/9/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "UIApplication+Extend.h"

@implementation UIApplication (Extend)

- (NSString *)version{
    // 系统直接读取的版本号
    NSString *versionValueStringForSystemNow = [[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    return versionValueStringForSystemNow;
}

@end
