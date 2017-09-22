//
//  ZYMallIntegralNetworkingRequst.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMallIntegralNetworkingRequst.h"
#import "Shop.h"
#import "Record.h"

@interface ZYMallIntegralNetworkingRequst ()
@property (nonatomic,assign)NSInteger myIntegralCurrentPage;
@property (nonatomic,assign)NSInteger exchangeRecordCurrentPage;
@end

@implementation ZYMallIntegralNetworkingRequst

- (NSMutableArray *)myIntegralModelsArray {
    if (!_myIntegralModelsArray) {
        _myIntegralModelsArray = [NSMutableArray array];
    }
    return _myIntegralModelsArray;
}

- (NSMutableArray *)exchangeRecordsArray {
    if (!_exchangeRecordsArray) {
        _exchangeRecordsArray = [NSMutableArray array];
    }
    return  _exchangeRecordsArray;
}



// 使用线程创造单例
+ (ZYMallIntegralNetworkingRequst *)shareInstance{
    static dispatch_once_t onceToken;
    static ZYMallIntegralNetworkingRequst *connect = nil;
    dispatch_once(&onceToken,^{
        connect = [[ZYMallIntegralNetworkingRequst alloc]init];
    });
    return connect;
}

- (AFHTTPRequestOperationManager *)loadMyIntegralWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result {
    __weak typeof(self) weakSelf = self;
    
    self.myIntegralCurrentPage = [parameters[@"page"] integerValue];
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    AFHTTPRequestOperationManager *manager = [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getShoplist >>>>>>>>>>> %@",dataBack);
        if (weakSelf.myIntegralCurrentPage == 0) {
            [weakSelf.myIntegralModelsArray removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            weakSelf.balance = content[@"balance"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Shop *shop = [[Shop alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error ====== %@",error);
                }
                [self.myIntegralModelsArray addObject:shop];
            }
            result(YES,nil);
        }else if([dataBack[@"code"] integerValue] == 46005){
            result(NO,@"你还没有兑换信息!");
            
        }else{
            result(NO,dataBack[@"message"]);

        }
    } failure:^(NSError *error) {
        result(NO,@"连接服务器失败!");

    }];
    
    return manager;

}

- (AFHTTPRequestOperationManager *)loadExchangeRecordsWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result {
    __weak typeof(self) weakSelf = self;

    self.exchangeRecordCurrentPage = [parameters[@"page"] integerValue];
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    AFHTTPRequestOperationManager *manager = [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getExchangeRecord >>>>>>>>>>> %@",dataBack);
        if (weakSelf.exchangeRecordCurrentPage == 0) {
            [weakSelf.exchangeRecordsArray removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Record *record = [[Record alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error ====== %@",error);
                }
                [weakSelf.exchangeRecordsArray addObject:record];
                result(YES,nil);
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (weakSelf.exchangeRecordsArray.count == 0) {
                result(YES,@"你还没有兑换信息!");
            }else{
                result(YES,@"没有更多了!");

            }
        }else{
            result(NO,dataBack[@"message"]);

        }
        
    } failure:^(NSError *error) {
        result(NO,@"连接服务器失败!");

    }];
    
    return manager;

}

@end
