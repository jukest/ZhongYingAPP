//
//  CinemaMapViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/9.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CinemaMapViewCtl : ZYViewController

@property(nonatomic,copy) NSString *name; //!<< 导航栏标题
@property(nonatomic) CLLocationCoordinate2D location; //!<< 影院位置

@end
