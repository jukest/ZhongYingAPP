//
//  ZYExchangeRecordsView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYExchangeRecordsView.h"
#import "ZYMallIntegralNetworkingRequst.h"


@implementation ZYExchangeRecordsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataExchangeTableView) name:@"UpdataExchangeRecordNotification" object:nil];
    }
    return self;
}

#pragma mark -- 通知
- (void)updataExchangeTableView {
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataMoreExchangeRecordNotification" object:nil];
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
    return 76;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZYMallIntegralNetworkingRequst shareInstance].exchangeRecordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeRecordCell"];
    Record *record = [ZYMallIntegralNetworkingRequst shareInstance].exchangeRecordsArray[indexPath.row];
    [cell configCellWithModel:record];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

@end
