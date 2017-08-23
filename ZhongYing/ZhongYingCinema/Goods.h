//
//  Goods.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Goods : JSONModel

@property(nonatomic,assign) NSInteger id; //!<<卖品id
@property(nonatomic,copy) NSString *name; //!<<卖品名称
@property(nonatomic,copy) NSString *images; //!<<卖品封面
@property(nonatomic,copy) NSString<Optional> *detail; //!<<卖品详情
@property(nonatomic,assign) NSInteger price; //!<<售卖价格
@property(nonatomic,assign) NSInteger type; //!<<卖品类型1-单品|2-合成品|3-套餐|4-纪念品

@end
