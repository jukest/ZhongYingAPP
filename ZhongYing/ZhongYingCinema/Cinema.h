//
//  Cinema.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/12.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Cinema : JSONModel

@property(nonatomic,copy) NSString<Optional> *id; //!<< 院列ID
@property(nonatomic,copy) NSString *title; //!<< 影院标题
@property(nonatomic,copy) NSString *phone; //!<< 影院电话
@property(nonatomic,copy) NSString *address; //!<< 影院地址
@property(nonatomic,copy) NSString<Optional> *distance; //!<< 影院距离，单位米，如果没有内容返回"-1"
@property(nonatomic,strong) NSNumber<Optional> *is_star; //!<< 是否关注
@property(nonatomic,strong) NSNumber<Optional> *lng; //!<< 影院经度，百度坐标
@property(nonatomic,strong) NSNumber<Optional> *lat; //!<< 影院纬度，百度坐标

@end
