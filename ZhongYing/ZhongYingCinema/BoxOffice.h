//
//  BoxOffice.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/2/10.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface BoxOffice : JSONModel

@property(nonatomic,copy) NSString *id; //!<< 影片片源ID
@property(nonatomic,copy) NSString *name; //!<< 影片名称
@property(nonatomic,copy) NSString *cover; //!<< 影片封面
@property(nonatomic,copy) NSString *release_time; //!<< 影片上映时间
@property(nonatomic,copy) NSString *today_box_office; //!<< 今日票房，单位：万
@property(nonatomic,copy) NSString *all_box_office; //!<< 历史票房，单位：万

@end
