//
//  Coupon.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/19.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Coupon : JSONModel

@property(nonatomic,copy) NSString<Optional> *id;  //!<<优惠券ID
@property(nonatomic,copy) NSString<Optional> *user_id;  //!<<用户ID
@property(nonatomic,copy) NSString<Optional> *price;  //!<<优惠券优惠金额
@property(nonatomic,copy) NSString<Optional> *type;  //!<<优惠券类型
@property(nonatomic,copy) NSString<Optional> *start_time;  //!<<优惠券开始生效时间
@property(nonatomic,copy) NSString<Optional> *end_time;  //!<<优惠券结束生效时间
@property(nonatomic,copy) NSString<Optional> *created_time;  //!<<资讯创建时间
@property(nonatomic,copy) NSString<Optional> *status;  //!<<优惠券的使用状态
@property(nonatomic,copy) NSString<Optional> *rate;  //!<<点击量

@end
