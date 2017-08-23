//
//  Record.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Record : JSONModel

@property(nonatomic,assign) NSInteger orderform_id; //!<<订单id
@property(nonatomic,copy) NSString *name;  //!<<积分商品名字
@property(nonatomic,assign) NSInteger score;  //!<<所需积分
@property(nonatomic,copy) NSString *created_time;  //!<< 兑换时间
@property(nonatomic,assign) NSInteger shop_type;  //!<< 积分卖品类型 1-电影票|2-单品（卖品）|3-观影套餐|4-纪念品

@end
