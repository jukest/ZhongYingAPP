//
//  ZYTabBarController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYTabBarController.h"
#import "ZYNavigationController.h"
#import "LoginViewController.h"
#import "InformationViewController.h"
#import "MainCimemaViewController.h"
#import "MainTableViewController.h"
#import "ZYMallViewController.h"
#import "ZYMapManager.h"
#import "ZYInformationMaintViewController.h"

#import "ZYMyViewController.h"

//#import "ZYConfirmTicketOrderViewController.h"


@interface ZYTabBarController ()

@end

@implementation ZYTabBarController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    NSArray *ctlNameArr = @[@"MainCimemaViewController",@"ZYMallViewController",@"ZYInformationMaintViewController",@"MyViewController"];
    //测试
    NSArray *ctlNameArr = @[@"MainCimemaViewController",@"ZYMallViewController",@"ZYInformationMaintViewController",@"ZYMyViewController"];

    NSArray *ctlTitleArr = @[@"影院",@"商城",@"资讯",@"我的"];
    NSArray *ctlIconArr = @[@"tabbar_info_selected",@"tabbar_mall_selected",@"tabbar_cinema_selected",@"tabbar_my_selected"];
    NSArray *ctlNotIconArr = @[@"tabbar_info_not_selected",@"tabbar_mall_not_selected",@"tabbar_cinema_not_selected",@"tabbar_my_not_selected"];
    NSMutableArray *ctlMutArr = [NSMutableArray array];
    for (int i=0; i<ctlNameArr.count; i++) {
        UIViewController *ctl = [[NSClassFromString(ctlNameArr[i]) alloc] init];
        UIImage *image = [UIImage imageNamed:ctlNotIconArr[i]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImage = [UIImage imageNamed:ctlIconArr[i]];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ctl.tabBarItem = [[UITabBarItem alloc]initWithTitle:ctlTitleArr[i] image:image selectedImage:selectImage];
        ctl.title = ctlTitleArr[i];
        [ctl.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        ZYNavigationController *ZYNav = [[ZYNavigationController alloc] initWithRootViewController:ctl];
        [ZYNav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [ctlMutArr addObject:ZYNav];
    }
    self.viewControllers = ctlMutArr;
    self.tabBar.tintColor = Color(252, 186, 0, 1.0);
    // 改变UITabBarController中UITabBar的颜色
    [[UITabBar appearance] setBarTintColor:Color(51, 55, 58, 1.0)];
    // 取消UITabBar的透明效果
    [UITabBar appearance].translucent = NO;
    self.selectedIndex = 0;
    
    // 去除返回按钮文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    // 账号在其他地方登陆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToCinemaViewController) name:@"AccountDidReLogin" object:nil];
    
    //添加通知 广告页 消失了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advertiseViewDismissNotification:) name:AdvertiseViewDismissNotification object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)showLoginViewController{
    LoginViewController *login = [[LoginViewController alloc] init];
    [login setHidesBottomBarWhenPushed:YES];
    ZYNavigationController *ZYNav = [[ZYNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:ZYNav animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showHudMessage:@"已经显示"];
}


- (void)popToCinemaViewController
{
    //相当于从moreController视图中一个一个地退出视图（Pop方式），直接退到UITabBarViewController的Item3中
    
    UINavigationController *oldNavigationController = [self.viewControllers objectAtIndex:self.selectedIndex];
    
    for (NSInteger i = [oldNavigationController.viewControllers count] - 1; i >= 0; i--) {
        
        UIViewController *viewController = [oldNavigationController.viewControllers objectAtIndex:i];
        
        [oldNavigationController popToViewController:viewController animated:NO];
        
    }
    
    //当不是UITabBarViewController不是第1项时，就强制切换到Item1
    
    if (0 != self.selectedIndex){
        
        self.selectedIndex = 0;
        
    }
    
    //在Item1中查找并获取到CinemaViewController视图
    
//    UINavigationController *newNavigationController = [self.viewControllers objectAtIndex:0];
//    MainCimemaViewController *cinemaViewCtl = [newNavigationController.viewControllers objectAtIndex:0];
//    MainTableViewController *mainTableViewVC = cinemaViewCtl.childViewControllers[0];
//    [mainTableViewVC.mainTableView removeFromSuperview];
//    cinemaViewCtl.currentPage = 0;
//    cinemaViewCtl.mainTableView = nil;
//    cinemaViewCtl.HUD = nil;
//    [cinemaViewCtl.slidersArr removeAllObjects];
//    [cinemaViewCtl.filmsArr removeAllObjects];
//    cinemaViewCtl.cinemaMsg = nil;
//    [cinemaViewCtl loadCinemaMessage];
    
//    UINavigationController *newNavigationController1 = [self.viewControllers objectAtIndex:1];
//    InformationViewController *informationCtl = [newNavigationController1.viewControllers objectAtIndex:0];
//    if (informationCtl.informationArr.count != 0) {
//        [informationCtl.informationTableView removeFromSuperview];
//        informationCtl.currentPage = 0;
//        informationCtl.informationTableView = nil;
//        [informationCtl.informationArr removeAllObjects];
//        [informationCtl.slidersArr removeAllObjects];
//    }
}

- (void)reSetCinemaViewController
{
//    UINavigationController *newNavigationController = [self.viewControllers objectAtIndex:0];
//    CinemaViewController *cinemaViewCtl = [newNavigationController.viewControllers objectAtIndex:0];
//    [cinemaViewCtl.cinemaTableView removeFromSuperview];
//    cinemaViewCtl.currentPage = 0;
//    cinemaViewCtl.cinemaTableView = nil;
//    cinemaViewCtl.HUD = nil;
//    [cinemaViewCtl.slidersArr removeAllObjects];
//    [cinemaViewCtl.filmsArr removeAllObjects];
//    cinemaViewCtl.cinemaMsg = nil;
    
//    UINavigationController *newNavigationController1 = [self.viewControllers objectAtIndex:1];
//    InformationViewController *informationCtl = [newNavigationController1.viewControllers objectAtIndex:0];
//    if (informationCtl.informationArr.count != 0) {
//        [informationCtl.informationTableView removeFromSuperview];
//        informationCtl.currentPage = 0;
//        informationCtl.informationTableView = nil;
//        [informationCtl.informationArr removeAllObjects];
//        [informationCtl.slidersArr removeAllObjects];
//    }
}

- (void)advertiseViewDismissNotification:(NSNotification *)notification {
    
    BOOL isUserCityChanged = [[NSUserDefaults standardUserDefaults] boolForKey:IsUserCityChanged];
    
    if (isUserCityChanged) {//发生了改变,提醒用户切换城市
        
        NSString *newCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"newCity"];
        NSString *oldCity = UserCurrentCityName;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"您所在的城市为%@,将为您切换到%@?",newCity,newCity] preferredStyle:UIAlertControllerStyleAlert];
        
        // 添加按钮
        __weak typeof(alert) weakAlert = alert;
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setObject:newCity forKey:@"currentCityName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:PositionCityChangedNotification object:nil];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IsUserCityChanged];
        
    } else {
        
        
    }
  
}

@end
