//
//  MyFilmComment.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/4.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface MyFilmComment : JSONModel

@property(nonatomic,assign) NSInteger id; //!<<影片评论的id
@property(nonatomic,strong) NSNumber<Optional> *movie_id; //!<< 影片ID
@property(nonatomic,copy) NSString *cover; //!<<影片的封面
@property(nonatomic,copy) NSString *name; //!<<影片的名字
@property(nonatomic,copy) NSString<Optional> *hall_name; //!<<观看影片的影厅名
@property(nonatomic,assign) NSNumber<Optional> *start_time; //!<<时间戳,影片播放的日期
@property(nonatomic,copy) NSString *stars; //!<<评分的等级
@property(nonatomic,copy) NSString *content; //!<<评分的内容
@property(nonatomic,assign) NSInteger comment_time; //!<<时间戳,发评论的时间
@property(nonatomic,copy) NSString<Optional> *cinema_name; //!<< 观看影片的影院名

@end
