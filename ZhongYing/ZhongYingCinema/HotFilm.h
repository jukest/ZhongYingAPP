//
//  HotFilm.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/12.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface HotFilm : JSONModel

@property(nonatomic,copy) NSString *id; //!< 影片ID
@property(nonatomic,copy) NSString *name; //!< 片名
@property(nonatomic,strong) NSArray<Optional> *tags; //!< 影厅标签
@property(nonatomic,strong) NSArray<NSString *><Optional> *label; //!< 影片标签
@property(nonatomic,copy) NSString<Optional> *sketch; //!< 电影简述
@property(nonatomic,assign) float stars; //!< 评分
@property(nonatomic,copy) NSString *cover; //!< 封面图片
@property(nonatomic,copy) NSString<Optional> *trailer; //!<  预告片
@property(nonatomic,strong) NSNumber<Optional> *is_hot; //!< 是否今日最热
@property(nonatomic,strong) NSNumber<Optional> *presell; //!< 是否是预售

@end
