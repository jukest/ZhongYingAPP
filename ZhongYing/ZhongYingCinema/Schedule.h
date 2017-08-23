//
//  Schedule.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Schedule : JSONModel

@property(nonatomic,assign) NSInteger start_time; //!<<影片开始时间
@property(nonatomic,assign) NSInteger end_time; //!<<影片结束时间
@property(nonatomic,assign) NSInteger market_price; //!<<售卖价格
@property(nonatomic,copy) NSString *name; //!<<影厅名字
@property(nonatomic,assign) NSInteger seat_available_num; //!<<该场次的剩余可售座位数
@property(nonatomic,copy) NSString <Optional>*tags; //!<<影院标签
@property(nonatomic,copy) NSString *language; //!<<配音
@property(nonatomic,assign) NSInteger id; //!<<放映计划的id
@property(nonatomic,assign) NSInteger time_type; //!<< 时间类型,1-今天|2-明天|3-后天
@property(nonatomic,assign) NSNumber<Optional> *is_now;  //!<< 是不是当前场次

@end
