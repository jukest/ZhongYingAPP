//
//  BoxOfficeTableViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "BoxOfficeTableViewCtl.h"
#import "BoxOfficeTableViewCell.h"
#import "BoxOfficeHeaderView.h"
#import "BoxOffice.h"

@interface BoxOfficeTableViewCtl ()
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *boxOfficeList; //!<< 票房数据源
@property(nonatomic,assign) NSInteger currentPage; //!<< 当前页数

@end

@implementation BoxOfficeTableViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BoxOfficeTableViewCell class] forCellReuseIdentifier:@"BoxOfficeTableViewCell"];
    //[self addRefreshView];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.currentPage = 0;
    [self loadBoxOfficeList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}

#pragma mark - Lazy Load
- (NSMutableArray *)boxOfficeList
{
    if (_boxOfficeList == nil) {
        _boxOfficeList = [NSMutableArray array];
    }
    return _boxOfficeList;
}

#pragma mark - help methods
- (void)loadBoxOfficeList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserCommonTicketListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"group_id"] = ApiGroup_ID;
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
    }
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getBoxOfficeList >>>>>>>>>> %@",dataBack);
        [self endRefresh];
        if ([dataBack[@"code"] integerValue] == 0) {
            if (self.currentPage == 0) {
                [self.boxOfficeList removeAllObjects];
            }
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                BoxOffice *boxOffice = [[BoxOffice alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"boxOffice_error = %@",error);
                }
                [self.boxOfficeList addObject:boxOffice];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
        }else if ([dataBack[@"code"] integerValue] == 46005){
            [self.parentViewController showHudMessage:@"没有票房排行"];
            
        }else{
            [self.parentViewController showHudMessage:dataBack[@"message"]];
        }
        [self.tableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self.parentViewController showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)addRefreshView
{
    __weak BoxOfficeTableViewCtl *boxOffice = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        boxOffice.currentPage = 0;
        [boxOffice loadBoxOfficeList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        boxOffice.currentPage ++;
        [boxOffice loadBoxOfficeList];
    }];
}

- (void)endRefresh
{
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.boxOfficeList.count;
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
    BoxOffice *boxOffice = self.boxOfficeList[indexPath.row];
    [cell configCellWithModel:boxOffice];
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
