//
//  ZhongYingConnect.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/12/10.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZhongYingConnectResult)(id dataBack,NSString *currentPager);
typedef void (^ZhongYingConnectFailed)(NSError *error);

@interface ZhongYingConnect : NSObject

+ (id)shareInstance;

// 回调字典接口[所有的接口通道，返回的是总字典]
- (AFHTTPRequestOperationManager *)getZhongYingDictSuccessURL:(NSString *)url parameters:(NSDictionary *)parameters result:(ZhongYingConnectResult)dataBack failure:(ZhongYingConnectFailed)failed;

// 上传数据使用
- (void)uploadZhongYingData:(NSData *)data fileName:(NSString *)fileName SuccessURL:(NSString *)url parameters:(NSDictionary *)parameters result:(ZhongYingConnectResult)dataBack failure:(ZhongYingConnectFailed)failed;

// 取消当前网络请求
- (void)cancel;

@end
