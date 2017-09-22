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
//导航控制器里面
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"movie_back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"movie_back"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.frame = CGRectMake(0, 0, 50, 30);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed=YES;
    }
    
    [super pushViewController:viewController animated:YES];
    
}

-(void)back{
    
    [self popViewControllerAnimated:YES];
    
    
}


@end
