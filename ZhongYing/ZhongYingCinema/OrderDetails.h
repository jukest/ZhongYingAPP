//
//  OrderDetails.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/16.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface OrderDetails : JSONModel

@property(nonatomic,copy) NSString *name; //!<<订单信息名字
@property(nonatomic,copy) NSString *cinema_name; //!<<影院名字
@property(nonatomic,copy) NSString<Optional> *hall_name; //!<<影厅名字
@property(nonatomic,copy) NSString<Optional> *time; //!<<播放时间
@property(nonatomic,copy) NSString *order_sn; //!<<订单号
@property(nonatomic,strong) NSArray<NSDictionary *><Optional> *seat; //!<<取票码
@property(nonatomic,copy) NSString *ticket_code; //!<<订单信息名字
@property(nonatomic,copy) NSString *qrcode; //!<<二维码路径
@property(nonatomic,assign) CGFloat total_price;
@property(nonatomic,assign)NSInteger type;
@end
