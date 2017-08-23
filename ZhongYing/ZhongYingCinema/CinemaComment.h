//
//  CinemaComment.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/14.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface CinemaComment : JSONModel

@property(nonatomic,copy) NSString *id;  //!<< 评论ID
@property(nonatomic,copy) NSString *stars;  //!<< 影院评分
@property(nonatomic,copy) NSString *content;  //!<< 评论内容
@property(nonatomic,copy) NSString *created_time;  //!<< 评论ID
@property(nonatomic,copy) NSString *title;  //!<< 评论时间

@end
