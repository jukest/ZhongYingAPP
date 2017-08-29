//
//  ZYMapManager.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMapManager.h"
#import<BaiduMapAPI_Map/BMKMapView.h>

#import<BaiduMapAPI_Location/BMKLocationService.h>


#import<BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import<BaiduMapAPI_Search/BMKPoiSearchType.h>



@interface ZYMapManager ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong)BMKLocationService *locService;  //定位
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;

/**
 纬度
 */
@property (nonatomic, assign,readwrite) CGFloat latitude;


/**
 经度
 */
@property (nonatomic, assign,readwrite) CGFloat longitude;



/**
 定位到城市名
 */
@property (nonatomic, copy, readwrite) NSString *cityName;


/**
 成功定位
 */
@property (nonatomic, assign, readwrite) BOOL successPosition;


/**
 成功反地理编码
 */
@property (nonatomic, assign, readwrite) BOOL successReverseGeoCode;



@end


@implementation ZYMapManager


#pragma mark -- 单例实现
// 创建静态对象 防止外部访问
static ZYMapManager *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}


// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareMapManager
{
    
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

#pragma mark -- 懒加载

-(BMKGeoCodeSearch *)searcher {
    if (!_searcher) {
        //初始化检索对象
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (BMKLocationService *)locService {
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return _locService;
}

#pragma mark -- 开启定位和关闭定位服务

- (void)starLocation {
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"lat"];//纬度
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"lng"];//经度
    
    if (lat.length == 0 || lng.length == 0) {
        
    } else {
        
         self.latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] floatValue];
         self.longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] floatValue];
        [self reverseGeoCode];
         return;
    }
    
    
    [self stopLocation];
    
    //启动LocationService
    [self.locService startUserLocationService];
}

- (void)stopLocation {
    //停止定位服务
    [self.locService stopUserLocationService];
    self.locService.delegate = nil;
    self.locService = nil;
    
    self.searcher.delegate = nil;
    self.searcher = nil;
    
}

#pragma mark - 编码与反编码 

/**
 地理编码
 */
- (void)geoCode {
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = @"海淀区上地10街10号";
    BOOL flag = [self.searcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索成功");
    }
    else
    {
        NSLog(@"geo检索失败");
    }
}


/**
 反地理编码
 */
- (void)reverseGeoCode {
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.latitude, self.longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
        if (self.locationBlock == nil) {
            
        } else {
            
            self.locationBlock(nil,NO);
        }
    }
}



#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_OPEN_NO_ERROR ) {
        
        self.successReverseGeoCode = YES;
        self.successPosition = YES;
        
        self.cityName = result.addressDetail.city;
        if (self.locationBlock == nil) {
            
        } else {
            
            self.locationBlock(self.cityName,YES);
        }
    } else {
        self.successReverseGeoCode = NO;
        self.locationBlock(nil,NO);
    }
    
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
}

#pragma mark - BMKLocationServiceDelegate
//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@",userLocation.heading);
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.successPosition = YES;
    
    
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    
    [self reverseGeoCode];
}


/**
 定位失败

 @param error 错误信息
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    
    self.successPosition = NO;
    
}




@end
