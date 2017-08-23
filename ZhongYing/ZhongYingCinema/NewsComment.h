//
//  NewsComment.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/14.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface NewsComment : JSONModel

@property(nonatomic,copy) NSString *id;  //!<< 评论ID
@property(nonatomic,copy) NSString *content;  //!<< 评论内容
@property(nonatomic,copy) NSString *created_time;  //!<< 评论时间
@property(nonatomic,copy) NSString *title;  //!<< 资讯标题

@end
