//
//  PaymentViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/1.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"

@interface PaymentViewCtl : ZYViewController

@property(nonatomic,strong) UITableView *paymentTableView;
@property(nonatomic,copy) NSString *orderform_id; //!<< 多个逗号隔开的订单id
@property(nonatomic,copy) NSString *coupon_id; //!<< 多个逗号隔开的优惠卷id
@property(nonatomic,copy) NSString *seat_id; //!<< 多个逗号隔开的座位id
@property(nonatomic,assign) NSInteger film_id; //!<< 场次id
@property(nonatomic,copy) NSString *goods; //!<< json形式的推荐商品
@property(nonatomic,copy) NSString *seats;
@property(nonatomic,assign) BOOL isTicket;

@property (nonatomic,assign) BOOL moreGoods;

@end
