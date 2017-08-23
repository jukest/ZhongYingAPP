//
//  DataConnect.m
//  OldManWatch
//
//  Created by 小菜皮 on 16/9/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "DataConnect.h"
#import "RechargeModel.h"

@implementation DataConnect

// 使用线程创造单例
+ (id)shareInstance{
    static dispatch_once_t onceToken;
    static DataConnect *connect = nil;
    dispatch_once(&onceToken,^{
        connect = [[DataConnect alloc]init];
    });
    return connect;
}

// 充值的选择充值的方式
- (void)createRechargeArr:(NSArray *)arr ToResultArr:(DataConnectResult)dataBack{
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    for (int i=0; i<arr.count; i++) {
        RechargeModel *model = [[RechargeModel alloc] init];
        model.chooseStr = [NSString stringWithFormat:@"%@",arr[i]];
        if (i == 0) {
            model.isOpen = YES;
        }else {
            model.isOpen = NO;
        }
        [mutArr addObject:model];
    }
    if (dataBack) {
        dataBack(mutArr);
    }
}

@end
