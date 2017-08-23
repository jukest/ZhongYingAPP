//
//  ZYMapManager.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^MapManagerLoactionBlock)(NSString *cityName,BOOL);


@interface ZYMapManager : NSObject

+(instancetype)shareMapManager;


/**
 开始定位
 */
- (void)starLocation;


/**
 停止定位
 */
- (void)stopLocation;



@property (nonatomic, strong) MapManagerLoactionBlock locationBlock;

/**
 纬度
 */
@property (nonatomic, assign,readonly) CGFloat latitude;


/**
 经度
 */
@property (nonatomic, assign,readonly) CGFloat longitude;


/**
 定位到的城市名字
 */
@property (nonatomic, copy, readonly) NSString *cityName;


/**
 成功定位
 */
@property (nonatomic, assign, readonly) BOOL successPosition;


/**
 成功反地理编码
 */
@property (nonatomic, assign, readonly) BOOL successReverseGeoCode;

@end
