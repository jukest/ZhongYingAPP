//
//  Shop.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Shop : JSONModel

@property(nonatomic,copy) NSString *id; //!<< 积分商品id
@property(nonatomic,assign) NSInteger type; //!<< 积分商品类型
@property(nonatomic,assign) NSInteger shop_type; //!< 积分卖品类型
@property(nonatomic,copy) NSString *name; //!<< 名字
@property(nonatomic,copy) NSString *cover; //!<< 封面
@property(nonatomic,copy) NSString *detail; //!<< 商品详情
@property(nonatomic,assign) NSInteger score; //!< 所需积分

@end
