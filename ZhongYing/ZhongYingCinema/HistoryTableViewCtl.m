//
//  HistoryTableViewCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/18.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "HistoryTableViewCtl.h"
#import "NoTicketCell.h"
#import "OrderDetailsCtl.h"

@interface HistoryTableViewCtl ()
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *orders;
@property(nonatomic,assign) NSInteger currentPage;

@end

@implementation HistoryTableViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = Color(245, 245, 245, 1.0);
    [self.tableView registerClass:[NoTicketCell class] forCellReuseIdentifier:@"NoTicketCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.currentPage = 0;
    
    [self addRefreshView];
    [self loadHistoryOrderform];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - help methods
- (void)loadHistoryOrderform
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserHistoryOrderformURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getHistoryOrderform >>>>>>>>>>> %@",dataBack);
        if (self.currentPage == 0) {
            [self.orders removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Order *order = [[Order alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error ====== %@",error);
                }
                [self.orders addObject:order];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (self.currentPage == 0) {
                [self.parentViewController showHudMessage:@"你还没有订单信息!"];
            }else{
                [self.parentViewController showHudMessage:@"没有订单了!"];
            }
        }else{
            [self.parentViewController showHudMessage:dataBack[@"message"]];
        }
        [self hideRefreshView];
        [self.tableView reloadData];
//        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [self hideRefreshView];
//        [_HUD hide:YES];
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
    __weak HistoryTableViewCtl *history = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        history.currentPage = 0;
        [history loadHistoryOrderform];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        history.currentPage ++;
        [history loadHistoryOrderform];
    }];
    //[self hideRefreshViewsubViews:self.tableView];
}

#pragma mark - 懒加载
- (NSMutableArray *)orders
{
    if (_orders == nil) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoTicketCell" forIndexPath:indexPath];
    Order *order = self.orders[indexPath.row];
    [cell configCellWithModel:order];
    cell.refundBtn.hidden = YES;
    cell.timeLb.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Order *order = self.orders[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailsCtl *orderDetails = [[OrderDetailsCtl alloc] init];
    orderDetails.order = order;
    [self.navigationController pushViewController:orderDetails animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}

@end
