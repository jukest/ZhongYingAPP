//
//  ZYInformationNewsView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationNewsView.h"
#import "InfoDetailsViewCtl.h"

@implementation ZYInformationNewsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataNewsData:) name:ZYInformationUpdataNewsDataNotification object:nil];
        
    }
    return self;
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
   
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.tableView reloadData];
        
        //发送通知 加载 更多数据
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYInformationUpdataMoreNewsDataNotification object:nil];
    }];

}

- (void)endRefresh {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}



#pragma mark -- ZYInformationUpdataNewsDataNotification

- (void)updataNewsData:(NSNotification *)noti {
    
    [self endRefresh];

    
    [self.tableView reloadData];
    if (self.tableView.mj_footer == nil) {
        
        [self addRefreshView];
    }
}

#pragma mrk -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZYInformantionMainNetworingRequst shareInstance].newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"informationTableViewCell" forIndexPath:indexPath];
    
    [cell configCellWithModel:[ZYInformantionMainNetworingRequst shareInstance].newsArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return InformationViewControllerTableViewCellHeight * heightFloat;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    InfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    InfoDetailsViewCtl *infoDetails = [[InfoDetailsViewCtl alloc] init];
    News *news = [ZYInformantionMainNetworingRequst shareInstance].newsArray[indexPath.row];
    news.rate = [NSString stringWithFormat:@"%zd",[cell.pageviewsBtn.titleLabel.text integerValue] +1];
    news.comment = cell.commentsBtn.titleLabel.text;
    infoDetails.news = news;
    infoDetails.commentBlock = ^void(NSInteger commentNum){
        [cell.commentsBtn setTitle:[NSString stringWithFormat:@"%zd",commentNum] forState:UIControlStateNormal];
    };
    
    infoDetails.rateBlock = ^void(NSInteger rateNum){
        [cell.pageviewsBtn setTitle:[NSString stringWithFormat:@"%zd",rateNum] forState:UIControlStateNormal];
    };
    [infoDetails setHidesBottomBarWhenPushed:YES];
    [vc.navigationController pushViewController:infoDetails animated:YES];

    
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
