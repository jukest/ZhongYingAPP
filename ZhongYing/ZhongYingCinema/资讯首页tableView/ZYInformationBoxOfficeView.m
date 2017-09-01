//
//  ZYInformationBoxOfficeView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationBoxOfficeView.h"
#import "BoxOfficeHeaderView.h"

@implementation ZYInformationBoxOfficeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBoxOfficeData:) name:ZYInformationUpdataBoxOfficeNotification object:nil];
        
    }
    return self;
}

#pragma mark -- ZYInformationUpdataBoxOfficeNotification

- (void)updataBoxOfficeData:(NSNotification *)noti {
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYInformationUpdataMoreBoxOfficeNotification object:nil];
    }];
    
}

- (void)endRefresh {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ZYInformantionMainNetworingRequst shareInstance].boxOfficesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titles = @[@"影片",@"今日票房\n(万)",@"历史票房\n(万)"];
    UIView *whiteView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 10) backgroundColor:[UIColor whiteColor]];
    BoxOfficeHeaderView *headerView = [[BoxOfficeHeaderView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50) titles:titles];
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 60) backgroundColor:[UIColor whiteColor]];
    [view addSubview:whiteView];
    [view addSubview:headerView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoxOfficeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoxOfficeTableViewCell" forIndexPath:indexPath];
    [cell configCellWithModel:[ZYInformantionMainNetworingRequst shareInstance].boxOfficesArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
