//
//  ZYNavigationController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYNavigationController.h"
#import "LoginViewController.h"

@interface ZYNavigationController ()

@end

@implementation ZYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 改变工具栏颜色
    self.navigationController.toolbar.barTintColor = Color(200, 186, 0, 1.0);
}

// 跳转到登录界面
- (void)showLoginViewController{
    LoginViewController *login = [[LoginViewController alloc] init];
    [login setHidesBottomBarWhenPushed:YES];
    [self pushViewController:login animated:YES];
}

@end
