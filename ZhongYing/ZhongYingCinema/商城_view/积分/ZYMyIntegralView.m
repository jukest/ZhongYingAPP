//
//  ZYMyIntegralView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMyIntegralView.h"
#import "ZYMallIntegralNetworkingRequst.h"
#import "ExchangeViewCtl.h"


@implementation ZYMyIntegralView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataTableView) name:@"UpdataMyIntegralNotification" object:nil];
    }
    return self;
}

#pragma mark -- 通知
- (void)updataTableView {
    
    [self endRefresh];
    
    [self.tableView reloadData];
    if (self.tableView.mj_footer == nil) {
        
        [self addRefreshView];
    }
    
    
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.tableView reloadData];
        
        //发送通知 加载 更多数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataMoreMyIntegralNotification" object:nil];
    }];
    
}

- (void)endRefresh {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}


#pragma mrk -- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZYMallIntegralNetworkingRequst shareInstance].myIntegralModelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIntegralCell"];
    Shop *shop = [ZYMallIntegralNetworkingRequst shareInstance].myIntegralModelsArray[indexPath.row];
    [cell configCellWithModel:shop];
    return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UIViewController *vc = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Shop *shop = [ZYMallIntegralNetworkingRequst shareInstance].myIntegralModelsArray[indexPath.row];
        ExchangeViewCtl *exchange = [[ExchangeViewCtl alloc] init];
        exchange.shop = shop;
        [exchange setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:exchange animated:YES];
    }


#pragma mark -- 获取当前控制器
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


@end
