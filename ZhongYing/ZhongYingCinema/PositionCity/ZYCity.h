//
//  ZYCity.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface ZYCity : JSONModel
@property (nonatomic,copy) NSString *city_key;
@property (nonatomic,copy) NSString *city_name;
@property (nonatomic,copy) NSString *initials;
@property (nonatomic,copy) NSString *pinyin;
@property (nonatomic,copy) NSString *short_name;
@end
