//
//  LoginData.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "LoginData.h"

static LoginData *_login = nil;

@implementation LoginData

+ (LoginData *)login{
    @synchronized (self) {
        if (!_login) {
            _login = [[LoginData alloc] init];
        }
    }
    return _login;
}

@end
