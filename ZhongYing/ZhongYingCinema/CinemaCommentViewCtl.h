//
//  CinemaCommentViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "Evaluate.h"
#import "MovieComment.h"

typedef void(^CinemaCommentBlock)(MovieComment *);

@interface CinemaCommentViewCtl : ZYViewController

@property(nonatomic,copy) NSString *id; //电影id或影院id

@property(nonatomic,copy) NSString *name; //title名称

@property(nonatomic,copy) NSString *type; //!<< 评价类型

@property(nonatomic,strong) Evaluate *evaluate; //!<< 待评价电影

@property(nonatomic,copy) CinemaCommentBlock block;

@end
