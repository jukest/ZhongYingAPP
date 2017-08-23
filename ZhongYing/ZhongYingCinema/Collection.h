//
//  Collection.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/30.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Collection : JSONModel

@property(nonatomic,assign) NSInteger id; //!<< 收藏列表的id
@property(nonatomic,assign) NSInteger movie_id; //!<< 影片ID
@property(nonatomic,copy) NSString *name; //!<< 电影的名称
@property(nonatomic,strong) NSArray *tags; //!<< 影厅的标签
@property(nonatomic,copy) NSString *length; //!<< 影片的时长(分钟)
@property(nonatomic,copy) NSString *cover; //!<< 影片的封面
@property(nonatomic,copy) NSString *source; //!<< 影片来源
//@property(nonatomic,assign) NSInteger created_time; //!<< 时间戳,记录创建日期
@property(nonatomic,strong) NSArray *label;

@end
