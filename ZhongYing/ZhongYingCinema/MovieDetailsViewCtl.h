//
//  MovieDetailsViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "HotFilm.h"
#import "Cinema.h"

typedef NS_ENUM(NSInteger,MovieDetailsViewEvents){
    MovieDetailsShareEvent = 10001,
    MovieDetailsBuyTicketEvent,
};

@interface MovieDetailsViewCtl : ZYViewController

@property(nonatomic,strong) UITableView *movieDetailsTableView;
@property(nonatomic,strong) HotFilm *hotFilm;
@property(nonatomic,strong) Cinema *cinemaMsg;   // 影院信息
@property(nonatomic,strong) NSMutableArray *filmsArr;   // 电影
@property(nonatomic,assign) NSInteger indexPath; // 当前电影的位置
@property(nonatomic,copy) NSString *type; //!<< 头部类型
@property(nonatomic,assign) BOOL isApn; //!< 判断是否点击消息来得

@end
