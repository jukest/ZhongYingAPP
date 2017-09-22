//
//  ZYMallIntegralNetworkingRequst.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYMallIntegralNetworkingRequst : NSObject

+ (ZYMallIntegralNetworkingRequst *)shareInstance;

/**
 我的积分能兑换的商品模型数组
 */
@property (nonatomic, copy) NSMutableArray *myIntegralModelsArray;


/**
 兑换记录模型数组
 */
@property (nonatomic, copy) NSMutableArray *exchangeRecordsArray;

@property (nonatomic, strong) NSNumber *balance;

/**
 加载我的积分

 @param urlStr url
 @param parameters 参数
 @param result 请求结果
 @return 返回manager
 */
- (AFHTTPRequestOperationManager *)loadMyIntegralWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;


/**
 加载交换记录

 @param urlStr url
 @param parameters 参数
 @param result 请求结果
 @return 返回manager
 */
- (AFHTTPRequestOperationManager *)loadExchangeRecordsWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;

@end
