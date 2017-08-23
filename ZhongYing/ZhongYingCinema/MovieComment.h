//
//  MovieComment.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/27.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface MovieComment : JSONModel

@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *stars;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *created_time;

@end
