//
//  Order.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/21.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Order : JSONModel

@property(nonatomic,strong) NSNumber *orderform_id; //!<< 订单ID
@property(nonatomic,strong) NSNumber *orderform_type; //!<< 订单类型 1-电影|2-卖品|3-积分商品
@property(nonatomic,strong) NSNumber<Optional> *score_type; //!<< 积分商品类型 1-电影|2-纪念品
@property(nonatomic,copy) NSString<Optional> *cinema_name; //!<< 电影院名字
@property(nonatomic,copy) NSString<Optional> *name; //!<< 卖品名字
//@property(nonatomic,copy) NSString<Optional> *movie_name; //!<< 电影名字
@property(nonatomic,copy) NSString<Optional> *cover; //!<< 电影封面
//@property(nonatomic,copy) NSString<Optional> *images; //!<< 卖品封面
@property(nonatomic,copy) NSString<Optional> *detail; //!<< 卖品详情
@property(nonatomic,strong) NSNumber<Optional> *price; //!<< 价格
@property(nonatomic,copy) NSString<Optional> *hall_name; //!<< 影厅名字
@property(nonatomic,strong) NSNumber<Optional> *time; //!<< 电影播放时间
//@property(nonatomic,copy) NSString<Optional> *score_name; //!<< 积分商城名字
@property(nonatomic,strong) NSNumber<Optional> *score; //!<< 所需积分

@end
