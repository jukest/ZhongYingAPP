//
//  ExchangeRecordTableViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ExchangeRecordTableViewCtl.h"
#import "ExchangeRecordCell.h"
#import "Record.h"
@interface ExchangeRecordTableViewCtl ()
{
    MBProgressHUD *_HUD;
}

@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray *recordList;
@end

@implementation ExchangeRecordTableViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped target:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[ExchangeRecordCell class] forCellReuseIdentifier:@"ExchangeRecordCell"];
    
    [self addRefreshView];
    
    self.currentPage = 0;
    [self loadExchangeRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help methods
- (void)loadExchangeRecord
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserExchangeRecordURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getExchangeRecord >>>>>>>>>>> %@",dataBack);
        if (self.currentPage == 0) {
            [self.recordList removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Record *record = [[Record alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error ====== %@",error);
                }
                [self.recordList addObject:record];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (self.currentPage == 0) {
                [self.parentViewController showHudMessage:@"你还没有兑换信息!"];
            }else{
                [self.parentViewController showHudMessage:@"没有更多了!"];
            }
        }else{
            [self.parentViewController showHudMessage:dataBack[@"message"]];
        }
        [self hideRefreshView];
        [self.tableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)hideRefreshView
{
    if (self.currentPage == 0) {
        [self.tableView.mj_header endRefreshing];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)addRefreshView
{
    __weak ExchangeRecordTableViewCtl *exchangeRecord = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        exchangeRecord.currentPage = 0;
        [exchangeRecord loadExchangeRecord];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        exchangeRecord.currentPage ++;
        [exchangeRecord loadExchangeRecord];
    }];
    //[self hideRefreshViewsubViews:self.tableView];
}

#pragma mark - 懒加载
- (NSMutableArray *)recordList
{
    if (_recordList == nil) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeRecordCell"];
    Record *record = self.recordList[indexPath.row];
    [cell configCellWithModel:record];
    return cell;
}


@end
