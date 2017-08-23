//
//  ShopDetail.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface ShopDetail : JSONModel

@property(nonatomic,assign) NSInteger id; //!<<积分商品id
@property(nonatomic,assign) NSInteger type; //!<<积分商品类型
@property(nonatomic,assign) NSInteger shop_type; //!<<积分卖品类型
@property(nonatomic,copy) NSString *name; //!<<名字
@property(nonatomic,copy) NSString *detail; //!<<商品详情
@property(nonatomic,assign) NSInteger score; //!<<所需积分
@property(nonatomic,assign) NSInteger goods_price; //!<<积分商品原价格
@property(nonatomic,copy) NSString *shop_detail; //!<<商品兑换详情说明
@property(nonatomic,assign) NSInteger start_time; //!<<时间戳，积分商品兑换活动开始时间
@property(nonatomic,assign) NSInteger end_time; //!<<时间戳，积分商品兑换活动结束时间

@end
