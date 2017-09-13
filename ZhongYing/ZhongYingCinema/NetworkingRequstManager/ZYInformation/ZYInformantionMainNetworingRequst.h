//
//  ZYInformantionMainNetworingRequst.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYInformantionMainNetworingRequst : NSObject


+ (ZYInformantionMainNetworingRequst *)shareInstance;


/**
 新闻模型数组
 */
@property (nonatomic, strong) NSMutableArray *newsArray;


/**
 票房模型数组
 */
@property (nonatomic, strong) NSMutableArray *boxOfficesArray;


/**
 轮播图数组
 */
@property (nonatomic, strong) NSMutableArray *sliderImgsArray;


/**
 加载资讯

 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
- (AFHTTPRequestOperationManager *)loadNewsWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;


/**
 加载票房

 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
- (AFHTTPRequestOperationManager *)loadBoxOfficWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;


/**
 加载轮播图

 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
//- (AFHTTPRequestOperationManager *)loadSliderImgWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;



@end
