//
//  CinemaDetailsViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "HotFilm.h"
#import "Cinema.h"

@interface CinemaDetailsViewCtl : ZYViewController

@property(nonatomic,strong) UITableView *cinemaDetailsTableView;
@property(nonatomic,strong) Cinema *cinemaMsg;   // 影院信息
@property(nonatomic,strong) NSMutableArray *filmsArr;   // 电影
@property(nonatomic,strong) HotFilm *film;  // 当前电影
@property(nonatomic,assign) NSInteger indexPath; // 当前电影的位置

@end
