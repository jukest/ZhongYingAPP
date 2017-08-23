//
//  CinemaMessageViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "Cinema.h"
@interface CinemaMessageViewCtl : ZYViewController

@property(nonatomic,strong) UITableView *cinemaMsgTableView;
@property(nonatomic,strong) NSMutableDictionary *message;
@property(nonatomic,strong) NSMutableArray *sliders;
@property(nonatomic,strong) Cinema *cinema;

@end
