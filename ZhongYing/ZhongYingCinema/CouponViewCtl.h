//
//  CouponViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/1.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"

typedef void(^couponBlock)(NSArray *);

@interface CouponViewCtl : ZYViewController

@property(nonatomic,strong) UITableView *couponTableView;
@property(nonatomic,strong) NSArray *coupon_ids;
@property(nonatomic,assign) BOOL hasSnack; //!<< 订单中是否包含小吃
@property(nonatomic,assign) BOOL hasTicket; //!<< 订单中是否包含电影
@property(nonatomic,copy) couponBlock block;

@end
