//
//  BoxOfficeViewController.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "BoxOfficeViewController.h"
#import "YSLContainerViewController.h"
#import "BoxOfficeTableViewCtl.h"
#import "FilmHeatTableViewCtl.h"

@interface BoxOfficeViewController ()<YSLContainerViewControllerDelegate>

@end

@implementation BoxOfficeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"票房";
    [self initBoxOfficeViewCtlUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help Methods
- (void)initBoxOfficeViewCtlUI
{
    BoxOfficeTableViewCtl *boxOffice = [[BoxOfficeTableViewCtl alloc] init];
    boxOffice.title = @"票房";
    
    FilmHeatTableViewCtl *filmHeat = [[FilmHeatTableViewCtl alloc] init];
    filmHeat.title = @"影片热度";
    
    [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"kYSLScrollMenuCount"];
    YSLContainerViewController *YSLContainer = [[YSLContainerViewController alloc] initWithControllers:@[boxOffice,filmHeat] topBarHeight:HEIGHT_STATUSBAR+HEIGHT_NAVBAR parentViewController:self];
    YSLContainer.delegate = self;
    YSLContainer.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
    [self.view addSubview:YSLContainer.view];
}

#pragma mark - YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [controller viewWillAppear:YES];
}

@end
