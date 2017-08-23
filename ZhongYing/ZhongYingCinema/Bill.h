//
//  Bill.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/28.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Bill : JSONModel

@property(nonatomic,assign) NSInteger id; //!<< 账单id
@property(nonatomic,assign) NSInteger type; //!<< 余额记录状态 1-支出|2-为收入
@property(nonatomic,copy) NSString *remark; //!<< 收支记录备注
@property(nonatomic,assign) float balance; //!<< 收支操作时的金额数
@property(nonatomic,assign) NSInteger operate_type; //!<< 所属操作的类型 1-电影票|2-卖品|3-充值|4-退票|5-退货|6-手续费
@property(nonatomic,assign) NSInteger created_time; //!<< 时间戳

@end
