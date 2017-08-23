//
//  AppDelegate.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

static BOOL isProduction = YES;

@interface AppDelegate : UIResponder<UIApplicationDelegate,BMKGeneralDelegate>{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

- (void)getAdvertisingImageWithCinemaID:(NSString *)cinema_id;

@end

