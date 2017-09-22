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
@property(nonatomic,assign) float market_price; //!<<售卖价格
@property(nonatomic,copy) NSString *name; //!<<影厅名字
@property(nonatomic,assign) NSInteger seat_available_num; //!<<该场次的剩余可售座位数
@property(nonatomic,copy) NSString <Optional>*tags; //!<<影院标签
@property(nonatomic,copy) NSString *language; //!<<配音
@property(nonatomic,assign) NSInteger id; //!<<放映计划的id
@property(nonatomic,assign) NSInteger time_type; //!<< 时间类型,1-今天|2-明天|3-后天
@property(nonatomic,assign) NSNumber<Optional> *is_now;  //!<< 是不是当前场次

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger weekDay;

@property (nonatomic, strong) NSString *showInfo;

@property (nonatomic, assign) NSInteger date;

/**
 通过字典数组 -> 模型数组

 @param keyValuesArray 字典数组
 @return 返回 模型数组
 */
+ (NSMutableArray *)wx_objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray;

@end
