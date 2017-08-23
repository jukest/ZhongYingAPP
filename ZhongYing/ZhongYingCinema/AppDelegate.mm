//
//  AppDelegate.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYTabBarController.h"
#import <CoreLocation/CoreLocation.h>
#import "BNCoreServices.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "YKGTabBarController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "MovieDetailsViewCtl.h"
#import "EvaluateViewCtl.h"
//#import "CinemaViewController.h"
#import "MainCimemaViewController.h"
#import "HotFilm.h"
#import "AdvertiseView.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "TipView.h"
#endif

@interface AppDelegate ()<CLLocationManagerDelegate,JPUSHRegisterDelegate>

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,assign) BOOL hasProcess;
@property(nonatomic,strong) NSDictionary *resultDic;
@property(nonatomic,strong) AdvertiseView *advertise;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 前往主界面ZYTabBarController
    [self gotoZYTabBarController];
    
    // 定位到自己的位置
    [self loadLocationMessage];
    // 初始化地图
    [self initMapManagerUI];
    // 初始化友盟分享
    [self initUMSocialShare];
    // 配置UMeng统计
    [self configUMStatistics];
    // 初始化APNs
    [self initAPNs];
    // 初始化JPush
    [self initJPushWithOptions:launchOptions];
    // 注册APPID
    [self registerWeChatAppID];
    // 定时器后台执行设置
    [self setNSTimerBackgroundActive];
    
    // 推送内容解析
    [self getPushMessage:launchOptions];
    
    // 添加广告页
    [self addAdvertiseView];
    
    return YES;
}

#pragma mark - 处理
// 添加广告
- (void)addAdvertiseView
{
    // 1.判断沙盒中是否存在图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        self.advertise = advertiseView;
        advertiseView.filePath = filePath;
        [advertiseView show];
    }
}


/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化页面
 */
- (void)getAdvertisingImageWithCinemaID:(NSString *)cinema_id
{
    
    // TODO 请求接口

    __block NSString *imageUrl; //= imageArray[arc4random() % imageArray.count];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiPublicAdPageURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cinema_id"] = cinema_id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getAdPage >>>>>>>>> %@",dataBack);
        NSDictionary *content = dataBack[@"content"];
        if ([dataBack[@"code"] integerValue] == 0) {
            imageUrl = [NSString stringWithFormat:@"%@%@",Image_URL,content[@"url"]];
            
            // 获取图片名:43-130P5122Z60-50.jpg
            NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
            NSString *imageName = stringArr.lastObject;
            
            // 拼接沙盒路径
            NSString *filePath = [self getFilePathWithImageName:imageName];
            BOOL isExist = [self isFileExistWithFilePath:filePath];
            if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
                
                [self downloadAdImageWithUrl:imageUrl imageName:imageName];
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有链接，将链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}

#pragma mark - APNs

/**
 处理推送消息

 @param launchOptions 推送的内容
 */
- (void)getPushMessage:(NSDictionary *)launchOptions
{
    // apn 内容获取：
    NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        NSLog(@"用户直接点击Apn被启动");
        // 把应用右上角的图标​去掉 这个最好写上，要不然强迫症会疯的
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        //​ 发通知
        [self performSelector:@selector(postGetPushMessageNotification:)withObject:userInfo afterDelay:1];
    }
}

- (void)postGetPushMessageNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JPushNotification" object:userInfo];
}

#pragma mark - 获取当前控制器/跳转控制器
// 跳转到目标VC
- (void)jumpToNotificationVC:(NSDictionary *)userInfo
{
    NSLog(@"userInfo = %@, ApiCinemaIDStr=%@",userInfo,ApiCinemaIDStr);
    UIViewController *vc = [self topVC:self.window.rootViewController];
    BOOL isNewCinema = NO;
    if (userInfo[@"cinema_id"] != nil && [ApiCinemaIDStr integerValue] != [userInfo[@"cinema_id"] integerValue]) {
        [self changeCinemaWithID:[userInfo[@"cinema_id"] integerValue]];
        [(ZYTabBarController *)vc.tabBarController reSetCinemaViewController];
        isNewCinema = YES;
    }
    
    if ([userInfo[@"type"] integerValue] == 1) {  // 收藏的影片 即将上映推送
        MovieDetailsViewCtl *movieDetails = [[MovieDetailsViewCtl alloc] init];
        HotFilm *film = [[HotFilm alloc] init];
        film.id = userInfo[@"movie_id"];
        film.trailer = @"";
        movieDetails.hotFilm = film;
        movieDetails.type = @"海报";
        movieDetails.isApn = YES;
        [movieDetails setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:movieDetails animated:YES];
    }else if([userInfo[@"type"] integerValue] == 2){ // 影片结束 去评价推送
        EvaluateViewCtl *evaluate = [[EvaluateViewCtl alloc] init];
        [evaluate setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:evaluate animated:YES];
    }else if ([userInfo[@"type"] integerValue] == 3){
        MovieDetailsViewCtl *movieDetails = [[MovieDetailsViewCtl alloc] init];
        HotFilm *film = [[HotFilm alloc] init];
        film.id = userInfo[@"movie_id"];
        film.trailer = @"";
        movieDetails.hotFilm = film;
        movieDetails.type = @"海报";
        movieDetails.isApn = YES;
        [movieDetails setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:movieDetails animated:YES];
    }else if ([userInfo[@"type"] integerValue] == 4){ // 活动推送
        if (![vc isKindOfClass:[MainCimemaViewController class]] || isNewCinema) {
            [(ZYTabBarController *)vc.tabBarController popToCinemaViewController];
        }
    }else if([userInfo[@"type"] integerValue] == 0){ // 更新推送
        [self showAlertWithMessage:userInfo[@"update"][@"update_title"] log:userInfo[@"update"][@"update_log"] downLoadUrl:userInfo[@"update"][@"ipa_download_url"] withController:vc];
    }
}

/**
 显示提示信息
 
 @param title 提示标题
 @param log   提示信息
 */
- (void)showAlertWithMessage:(NSString *)title log:(NSString *)log downLoadUrl:(NSString *)url withController:(UIViewController *)viewController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:log preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        // 服务器后台给一个链接让我更新
        NSURL *updateUrl = [NSURL URLWithString:url];
        if (updateUrl) {
            if ([[UIApplication sharedApplication] canOpenURL:updateUrl]) {
                if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:updateUrl];
                }else{
                    [[UIApplication sharedApplication] openURL:updateUrl options:@{} completionHandler:nil];
                }
            }
        }
    }];
    if ([deleteAction valueForKey:@"titleTextColor"]) {
        [deleteAction setValue:Color(251, 158, 29, 1.0) forKey:@"titleTextColor"];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [deleteAction setValue:Color(251, 158, 29, 1.0) forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)changeCinemaWithID:(NSInteger)cinema_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonChangeCinemaURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = @(cinema_id);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getChangeCinema >>>>>>>> %@",dataBack);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(int)cinema_id] forKey:@"Apicinema_id"];// 影院ID
    } failure:^(NSError *error) {
        //[self showHudMessage:@"连接服务器失败！"];
    }];
}

// 获取当前VC
- (UIViewController *)topVC:(UIViewController *)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navc = (UINavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}


/**
 根试图控制器
 */
- (void)gotoZYTabBarController{
    
    NSMutableArray *ctlArr=[NSMutableArray array];
    ZYTabBarController *ZYTabCtl = [[ZYTabBarController alloc] init];
    [ctlArr addObject:ZYTabCtl];
    
    YKGTabBarController *tabCtl = [[YKGTabBarController alloc]init];
    tabCtl.tabBar.hidden = YES;
    tabCtl.viewControllers = ctlArr;
    self.window.rootViewController = tabCtl;
    
    [self.window makeKeyAndVisible];
}

// 设置定时器后台有效
- (void)setNSTimerBackgroundActive
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
}

#pragma mark - 第三方初始化(百度地图、umeng分享、推送等)
// 初始化地图
- (void)initMapManagerUI
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:NAVI_TEST_APP_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"地图管理启动失败!");
    }
    //授权TTS必须品
    [BNCoreServices_Instance setTTSAppId:@"9288147"];

    [BNCoreServices_Instance initServices:NAVI_TEST_APP_KEY];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
}

// 注册APPID
- (void)registerWeChatAppID
{
    // [WXApi registerApp:UM_WECHAT_APP_KEY withDescription:@"JKMovies1.0.2"];
    [WXApi registerApp:UM_WECHAT_APP_KEY];
}

// 初始化友盟分享
- (void)initUMSocialShare
{
    //打开调试日志
    // [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_TEST_APP_KEY];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UM_WECHAT_APP_KEY appSecret:UM_WECHAT_APP_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:UM_WECHAT_APP_KEY appSecret:UM_WECHAT_APP_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UM_QQ_APP_KEY  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:UM_QQ_APP_KEY  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UM_SINA_APP_KEY  appSecret:UM_SINA_APP_SECRET redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    // 如果不想显示平台下的某些类型，可用以下接口设置
    //    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_YixinTimeLine),@(UMSocialPlatformType_LaiWangTimeLine),@(UMSocialPlatformType_Qzone)]];
}


/**
 初始化umeng统计
 */
- (void)configUMStatistics
{
    UMConfigInstance.appKey = UM_TEST_APP_KEY;
    // 统计应用来源
    UMConfigInstance.channelId = @"App Store";
    // 版本统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setEncryptEnabled:YES];
    // 开启统计
    [MobClick startWithConfigure:UMConfigInstance];
    
}

/**
 初始化极光推送
 */
- (void)initAPNs
{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
}

/**
 初始化极光推送
 */
- (void)initJPushWithOptions:(NSDictionary *)launchOptions
{
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPush_APP_KEY
                          channel:@"App Store"
                 apsForProduction:isProduction];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
}


/**
 极光登录成功通知

 @param note 通知体
 */
- (void)networkDidLogin:(NSNotification *)note
{
    NSLog(@"极光推送已Login");
    [[NSUserDefaults standardUserDefaults] setObject:[JPUSHService registrationID] forKey:@"registrationID"];
}

// 定位
- (void)loadLocationMessage
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
}


- (void)processOfOtherUrl:(NSURL *)url
{
    // 其他如支付等SDK的回调
    if ([url.host isEqualToString:@"safepay"]) { // 支付宝
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            self.hasProcess = YES;
            self.resultDic = resultDic;
        }];
    }
}

// 开场前30分钟提醒
- (void)getFilmTime
{
    if ([isOrderForTicket isEqualToString:@"YES"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserGetFilmTimeURL];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            NSLog(@"getFilmTime >>>>>>>>>>>>>> %@",dataBack);
            NSArray *list = dataBack[@"content"][@"list"];
            if (list.count != 0) {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isOrderForTicket"];
                TipView *tipView = [[TipView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 400)];
                [tipView configTipView:[list lastObject]];
                [tipView show];
                [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.advertise];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }else{  //本地通知
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self jumpToNotificationVC:userInfo];
    }else{  //本地通知
        [JPUSHService handleRemoteNotification:userInfo];
        JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
        identifier.identifiers = @[@"sampleRequest"];
        [JPUSHService removeNotification:identifier];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    NSLog(@"userInfo = %@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    [self jumpToNotificationVC:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    NSLog(@"userInfo = %@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    [self jumpToNotificationVC:userInfo];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"google lat= %f,lng = %f",coordinate.latitude,coordinate.longitude);
    
    // WGS_84 转化为百度坐标
    coordinate = [self WGS84ToBD09:coordinate];
    NSLog(@"baidu lat= %f,lng = %f",coordinate.latitude,coordinate.longitude);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"lng"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"lat"];
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        NSLog(@"定位失败!");
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lng"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lat"];
    }
}

- (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)yGps{
    
    //转换国测局坐标（google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标）至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(yGps,BMK_COORDTYPE_COMMON);
    
    //转换WGS84坐标至百度坐标(加密后的坐标)
    testdic = BMKConvertBaiduCoorFrom(yGps,BMK_COORDTYPE_GPS);
    
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    //解密加密后的坐标字典
    
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
    return baiduCoor;
}

#pragma mark - UIApplicationDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    if (!result) {
        // 其他如支付等SDK的回调
        [self processOfOtherUrl:url];
    }
    return result;
}

// 仅支持iOS9以上系统，iOS8及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    if (!result) {
        // 其他如支付等SDK的回调
        [self processOfOtherUrl:url];
    }
    return result;
}

// 支持目前所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    if (!result) {
        // 其他如支付等SDK的回调
        [self processOfOtherUrl:url];
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 设置导航栏状态栏为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self getFilmTime];
    if (self.hasProcess) {
        if ([isProcessFromPayment isEqualToString:@"YES"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getAlipayProcessFromPayment" object:self.resultDic];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProcessFromPayment"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getAlipayProcessFromRecharge" object:self.resultDic];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProcessFromPayment"];
        }
        self.hasProcess = NO;
    }
}

// 后台仍然执行定时器
- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    // 设置导航栏状态栏为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
