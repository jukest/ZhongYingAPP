//
//  FilmComment.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/30.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface FilmComment : JSONModel

@property(nonatomic,assign) NSInteger id;  //!<< 影片评论的id
@property(nonatomic,assign) NSInteger stars;  //!<< 影片的评分等级
@property(nonatomic,copy) NSString *content;  //!<< 影片的评论内容
@property(nonatomic,copy) NSString *cover;  //!<< 影片的封面
@property(nonatomic,copy) NSString *name;  //!<< 影片的名字
@property(nonatomic,assign) NSInteger created_time;  //!<< 时间戳,记录创建日期

@end
