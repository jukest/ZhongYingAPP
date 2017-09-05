//
//  ZYConfirmTicketOrderViewController.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "ZFSeatButton.h"
#import "Schedule.h"


@interface ZYConfirmTicketOrderViewController : ZYViewController
@property(nonatomic,assign) NSInteger film_id; //!<< 场次id
@property(nonatomic,copy) NSString *seat_id; //!<< 座位id
@property(nonatomic,copy) NSString *goods_info; //!<< 卖品参数
@property(nonatomic,copy) NSString *cinema_name; //!<< 影院名
@property(nonatomic,strong) NSArray<ZFSeatButton *> *selectedSeats; //!<< 座位

@property(nonatomic,strong) NSDictionary *film;  //!<< 当前影片信息


/**
 选择的电影的时间
 */
@property (nonatomic, strong) Schedule *schedule;

@property(nonatomic,assign) BOOL hasSnack;  //!< 是否有卖品

@end
