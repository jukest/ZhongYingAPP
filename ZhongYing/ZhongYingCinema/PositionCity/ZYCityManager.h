//
//  ZYCityManager.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZYCityManager : NSObject


+(instancetype)shareCityManager;

@property (nonatomic,copy) NSArray *cityGroups;

@property (nonatomic,copy) NSArray <NSString *> *cityFirstLetters;

@end
