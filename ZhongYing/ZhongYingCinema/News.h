//
//  News.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/12.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface News : JSONModel

@property(nonatomic,copy) NSString *id;  //!<< 资讯ID
@property(nonatomic,copy) NSString *title;  //!<< 资讯标题
@property(nonatomic,copy) NSString *cover;  //!<< 影院地址
@property(nonatomic,copy) NSString *created_time;  //!<< 资讯创建时间，时间戳
@property(nonatomic,copy) NSString *comment;  //!<< 评论总数
@property(nonatomic,copy) NSString *rate;  //!<< 点击量
@property(nonatomic,copy) NSString<Optional> *category; //!<< 新闻分类

@end
