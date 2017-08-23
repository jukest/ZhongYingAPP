//
//  LoginData.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginData : NSObject

// 是否处于登陆状态
@property (nonatomic,assign) BOOL isLogin;

+ (LoginData *)login;

@end
