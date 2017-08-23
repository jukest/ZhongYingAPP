//
//  DataConnect.h
//  OldManWatch
//
//  Created by 小菜皮 on 16/9/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataConnectResult)(id dataBack);

@interface DataConnect : NSObject

+ (id)shareInstance;
// 充值的选择充值的方式
- (void)createRechargeArr:(NSArray *)arr ToResultArr:(DataConnectResult)dataBack;

@end
