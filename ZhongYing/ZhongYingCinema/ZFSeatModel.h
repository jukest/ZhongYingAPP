//
//  ZFSeatModel.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/3.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface ZFSeatModel : JSONModel

@property(nonatomic,copy) NSString *x;  //!<<座位横坐标
@property(nonatomic,copy) NSString *y;  //!<<座位纵坐标
@property(nonatomic,copy) NSString *rowValue;  //!<<座位排号
@property(nonatomic,copy) NSString *columnValue;  //!<<座位列号
@property(nonatomic,copy) NSString *cineSeatId;  //!<<影院座位id
@property(nonatomic,copy) NSString *seatStatus;  //!<<座位状态(可购买 : ok, 已锁定 : locked,已预订: booked, 已出售 : selled, 不可用: repair)
@property(nonatomic,copy) NSString *type;  //!<<座位类型（road：过道，danren：单人，shuangren：双人，baoliu：保留座，canji：残疾人座，vip：VIP会员座，zhendong：震动座）
@property(nonatomic,copy) NSString *pairValue;  //!<<情侣座标识(两个pairValue值相同的就是情侣座.如：seats_8_16表示8排16号情侣座,和另一个pairValue=seats_8_16的座位是一对情侣座。值为空的不是情侣座)

@end
