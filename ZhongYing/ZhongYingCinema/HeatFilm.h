//
//  HeatFilm.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/5.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface HeatFilm : JSONModel

@property(nonatomic,assign) NSInteger id; //!<<影片片源id
@property(nonatomic,copy) NSString *name; //!<<影片名称
@property(nonatomic,copy) NSString *cover; //!<<影片封面
@property(nonatomic,copy) NSString *release_time; //!<<时间戳,影片上映时间
@property(nonatomic,assign) NSInteger comments; //!<<影片影评分

@end
