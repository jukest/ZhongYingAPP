//
//  Souvenir.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/7.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Souvenir : JSONModel

@property(nonatomic,copy) NSString *id; //!<<卖品id
@property(nonatomic,copy) NSString *price; //!<<卖品名称
@property(nonatomic,copy) NSString *name; //!<<卖品封面
@property(nonatomic,copy) NSString *detail; //!<<卖品详情
@property(nonatomic,copy) NSString *type; //!<<售卖价格
@property(nonatomic,copy) NSString *images; //!<<卖品类型1-单品|2-合成品|3-套餐|4-纪念品

@end
