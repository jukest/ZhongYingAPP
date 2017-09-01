//
//  ZhongYingConnect.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/12/10.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZhongYingConnect.h"

@implementation ZhongYingConnect
{
    AFHTTPRequestOperationManager *_manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFCompoundResponseSerializer serializer];
        
        //申明请求的数据是json类型
//        _manager.requestSerializer=[AFJSONRequestSerializer serializer];//请求类型
        
        // 响应类型
//        [_manager.requestSerializer setValue:APP_key forHTTPHeaderField:@"APP_key"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil, nil];
        
        
        // 设置网络超时时间
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 10.f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return self;
}

// 使用线程创造单例
+ (id)shareInstance{
    static dispatch_once_t onceToken;
    static ZhongYingConnect *connect = nil;
    dispatch_once(&onceToken,^{
        connect = [[ZhongYingConnect alloc]init];
    });
    return connect;
}

// 回调字典接口[所有的接口通道，返回的是总字典]
- (AFHTTPRequestOperationManager *)getZhongYingDictSuccessURL:(NSString *)url parameters:(NSDictionary *)parameters result:(ZhongYingConnectResult)dataBack failure:(ZhongYingConnectFailed)failed{
    [_manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"调用接口：%@ 回调数据：%@",url,dict);
        if (dataBack) {
            if ([dict[@"code"] integerValue] == 50003) {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiid"];// 用户ID
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apimobile"];// 手机号码
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiname"];// 用户姓名
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apinickname"];// 用户昵称
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiavatar"];// 头像
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apigender"];// 性别，枚举值，0-未设置|1-男|2-女
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiage"];// 年龄，枚举值，0-未设置|1-20岁以下|2-20-30岁|3-31-40岁|4-40岁以上
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apitoken"];// 令牌，请求其它接口时需要
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"UserLogin"];// 设置登录状态为NO
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"myremain"];// 余额
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"myscore"];// 积分
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"mycomment"];// 评论
                
                // 账号在其他地方登陆通知
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountDidReLogin" object:nil];
                });
                
                //umeng统计账号登出需调用此接口，调用之后不再发送账号相关内容。
                [MobClick profileSignOff];
            }
            dataBack(dict,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error);
    }];
    return _manager;
}

// 上传数据使用
- (void)uploadZhongYingData:(NSData *)data fileName:(NSString *)fileName SuccessURL:(NSString *)url parameters:(NSDictionary *)parameters result:(ZhongYingConnectResult)dataBack failure:(ZhongYingConnectFailed)failed
{
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"avatar" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"调用接口：%@ 回调数据：%@",url,dict);
        if (dataBack) {
            dataBack(dict,nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failed(error);
    }];
}

// 取消当前网络请求
- (void)cancel
{
    [_manager.operationQueue cancelAllOperations];
}

@end
