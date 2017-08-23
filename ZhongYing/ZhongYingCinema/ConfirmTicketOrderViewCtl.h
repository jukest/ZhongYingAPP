//
//  ConfirmTicketOrderViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "ZFSeatButton.h"

@interface ConfirmTicketOrderViewCtl : ZYViewController

@property(nonatomic,assign) NSInteger film_id; //!<< 场次id
@property(nonatomic,copy) NSString *seat_id; //!<< 座位id
@property(nonatomic,copy) NSString *goods_info; //!<< 卖品参数
@property(nonatomic,copy) NSString *cinema_name; //!<< 影院名
@property(nonatomic,strong) NSArray<ZFSeatButton *> *selectedSeats; //!<< 座位

@property(nonatomic,strong) UIButton *countdownLb;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *typeLb;
@property(nonatomic,strong) UILabel *cinemaNameLb;
@property(nonatomic,strong) UILabel *hallLb;
@property(nonatomic,strong) UILabel *seatNumberLb;
@property(nonatomic,strong) UILabel *snackLb;
@property(nonatomic,strong) UILabel *totalPriceLb;
@property(nonatomic,strong) UIButton *couponLb;
@property(nonatomic,strong) UILabel *finalPaymentLb;

@property(nonatomic,strong) UITableView *recommendTableView;

@property(nonatomic,assign) BOOL hasSnack;  //!< 是否有卖品

@end
