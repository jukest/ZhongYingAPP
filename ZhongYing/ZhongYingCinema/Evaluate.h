//
//  Evaluate.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/4.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Evaluate : JSONModel

@property(nonatomic,assign) NSInteger movie_id; //!<< 影片的id
@property(nonatomic,copy) NSString *cover; //!<< 影片的封面
@property(nonatomic,copy) NSString *name; //!<< 影片的名字
@property(nonatomic,copy) NSString *hall_name; //!<< 观看影片的影厅名
@property(nonatomic,assign) NSInteger start_time; //!<< 时间戳,影片播放的日期
@property(nonatomic,copy) NSString<Optional> *cinema_name; //!<< 观看影片的影院名

@end
