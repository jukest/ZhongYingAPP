//
//  CinemaMapViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/9.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "CinemaMapViewCtl.h"
#import "BNCoreServices.h"
#import "BNRoutePlanModel.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface CinemaMapViewCtl ()<BMKMapViewDelegate,BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate,BMKLocationServiceDelegate>
{
    CGFloat _longitudeF;
    CGFloat _latitudeF;
}
// 地图
@property (nonatomic,strong) BMKMapView *mapView;
// 导航类型，分为模拟导航和真实导航
@property (assign, nonatomic) BNaviUIType naviType;
@property (nonatomic,strong) BMKLocationService *locationService;

@end

@implementation CinemaMapViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.name;
    UIButton *rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:@"导航" titleColor:[UIColor whiteColor] target:self action:@selector(gotoNavigationEvent) tag:100];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self initMapViewUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - help methods
- (void)initMapViewUI{
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    _mapView.delegate = self;
    // 显示定位图层
    _mapView.showsUserLocation = YES;
    // 显示比例尺
    _mapView.showMapScaleBar = YES;
    // 地图显示的级别
    _mapView.zoomLevel = 17;
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
    pointAnnotation.coordinate = self.location;
    pointAnnotation.title = self.name;
    [_mapView addAnnotation:pointAnnotation];
    _mapView.centerCoordinate = self.location;
    [self.view addSubview:_mapView];
    
    // 初始化BMKLocationService
    _locationService = [[BMKLocationService alloc] init];
    _locationService.distanceFilter = 100.0f;
    _locationService.desiredAccuracy = kCLLocationAccuracyBest;
    if (System_Ver >= 8.0) {
        [_locationService allowsBackgroundLocationUpdates];
    }
    _locationService.delegate = self;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    // 启动LocationService
    [_locationService startUserLocationService];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self showHudMessage:@"请检查GPS权限"];
    }
}

- (BOOL)checkServicesInited{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self showHudMessage:@"请检查GPS权限"];
        return NO;
    }else if(![BNCoreServices_Instance isServicesInited]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"引擎尚未初始化完成，请稍后再试" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - 开始导航
- (void)startNavi{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    // 起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = _longitudeF;
    startNode.pos.y = _latitudeF;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    
    // 终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = self.location.longitude;
    endNode.pos.y = self.location.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

- (id)naviPresentedViewController
{
    return self;
}

#pragma mark - view handle
- (void)gotoNavigationEvent
{
    // 导航
    if (![self checkServicesInited]) return;
    _naviType = BNaviUI_NormalNavi;
    [self startNavi];
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    // 保存定位位置的经纬度
    // 保存定位位置的经纬度
    _latitudeF = userLocation.location.coordinate.latitude;
    _longitudeF = userLocation.location.coordinate.longitude;
    
    // 动态更新我的位置
    [_mapView updateLocationData:userLocation];
    [_locationService stopUserLocationService];
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    
    //设置标题 70
    CGSize titleSize = [FanShuToolClass createString:self.name font:[UIFont systemFontOfSize:15] lineSpacing:3 maxSize:CGSizeMake(150, ScreenHeight)];
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, titleSize.width +25, titleSize.height +10 +15)];
    //设置弹出气泡图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paopao"]];
    image.frame = CGRectMake(0, 0, titleSize.width +25, titleSize.height +10 +15);
    [popView addSubview:image];
    
    UILabel *title = [FanShuToolClass createLabelWithFrame:CGRectMake(13, 5, titleSize.width, titleSize.height) text:self.name font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    //title.adjustsFontSizeToFitWidth = YES;
    title.numberOfLines = 0;
    [image addSubview:title];
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = CGRectMake(0, 0, titleSize.width +25, titleSize.height +10 +15);
    newAnnotationView.paopaoView = pView;
    newAnnotationView.image = [UIImage imageNamed:@"location"];
    newAnnotationView.selected = YES;
    
    return newAnnotationView;
}

#pragma mark - BNNaviRoutePlanDelegate
//   算路成功回调
- (void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
}

//   算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    //NSLog(@"算路失败");
    NSString *message;
    switch ([error code] % 10000) {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            NSLog(@"%@",message = @"暂时无法获取您的位置，请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            NSLog(@"%@",message = @"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            NSLog(@"%@",message = @"定位服务未开启，请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            NSLog(@"%@",message = @"起终点距离太近");
            break;
        default:
            NSLog(@"%@",message = @"算路失败");
            break;
    }
    [self showHudMessage:message];
}

//  算路取消回调
- (void)routePlanDidUserCanceled:(NSDictionary *)userInfo
{
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate
- (void)onExitPage:(BNaviUIType)pageType extraInfo:(NSDictionary *)extraInfo
{
    if (pageType == BNaviUI_NormalNavi) {
        NSLog(@"退出导航");
    }else if (pageType == BNaviUI_Declaration){
        NSLog(@"退出导航声明页面");
    }
}

@end
