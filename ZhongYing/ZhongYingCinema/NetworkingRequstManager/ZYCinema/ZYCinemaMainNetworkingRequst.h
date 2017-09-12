//
//  ZYCinemaMainNetworkingRequst.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cinema;
@interface ZYCinemaMainNetworkingRequst : NSObject

+ (ZYCinemaMainNetworkingRequst *)shareInstance;

@property (nonatomic,strong)Cinema *cinemaMsg;

/**
 正在上映模型数组
 */
@property (nonatomic, strong) NSMutableArray *nowPlayingFilmArray;


/**
 即将上映模型数组
 */
@property (nonatomic, strong) NSMutableArray *willPlayFilmsArray;


/**
 轮播图数组
 */
@property (nonatomic, strong) NSMutableArray *sliderImgsArray;


/**
 加载正在上映
 
 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
- (AFHTTPRequestOperationManager *)loadNowPlayingFilmWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;


/**
 加载即将上映
 
 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
- (AFHTTPRequestOperationManager *)loadWillPlayFilmWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;


/**
 加载轮播图
 
 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
- (AFHTTPRequestOperationManager *)loadSliderImgWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result;


@end
