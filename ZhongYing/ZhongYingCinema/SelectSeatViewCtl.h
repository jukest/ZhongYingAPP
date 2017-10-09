//
//  SelectSeatViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/2.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "Schedule.h"
#import "Goods.h"
#import "HotFilm.h"
#import "Cinema.h"

@interface SelectSeatViewCtl : ZYViewController

@property(nonatomic,strong) UITableView *SelectSeatTableView;
@property(nonatomic,strong) Schedule *schedule; // 排片表
@property(nonatomic,strong) HotFilm *hotFilm;  //影片信息
@property(nonatomic,strong) Cinema *cinemaMsg;   // 影院信息
@property(nonatomic,strong) NSMutableArray *goodsList;  //卖品
@property(nonatomic,assign) NSInteger index; //   0-今天/1-明天/2后天

@property(nonatomic,strong) NSString *serviceMoney;//服务费

@end
