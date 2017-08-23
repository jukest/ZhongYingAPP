//
//  Movie.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/27.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Movie : JSONModel

@property(nonatomic,assign) NSInteger id; //!<< 积分商品id
@property(nonatomic,copy) NSString *name; //!<< 影片名字
@property(nonatomic,copy) NSString *english_name;//!<< 影片英文名字
@property(nonatomic,copy) NSString *source; //!<< 来源
@property(nonatomic,copy) NSString *length; //!<< 片长
@property(nonatomic,copy) NSString *release_area; //!<< 上映地点
@property(nonatomic,copy) NSString *release_time; //!<< 上映时间
@property(nonatomic,copy) NSString *detail; //!<< 电影详情
@property(nonatomic,copy) NSString *trailer; //!<< 电影预告片
@property(nonatomic,copy) NSString *cover; //!<< 电影封面
@property(nonatomic,strong) NSArray<NSString *><Optional> *picture; //!<< 电影图片
@property(nonatomic,strong) NSArray<NSString *><Optional> *label; //!<< 电影标签
@property(nonatomic,assign) BOOL collection; //!<< 是否收藏

@end
