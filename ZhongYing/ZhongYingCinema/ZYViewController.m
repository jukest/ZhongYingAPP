//
//  ZYViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"

@interface ZYViewController ()

@end

@implementation ZYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self resetBackBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 设置导航栏状态栏为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 设置导航栏的背景颜色
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
}

- (void)resetBackBarItem
{
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    
   
    
    int  previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@"xx"
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
}

@end
