//
//  MyIntegralTableViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyIntegralTableViewCtl.h"
#import "MyIntegralCell.h"
#import "ExchangeViewCtl.h"
#import "Shop.h"

@interface MyIntegralTableViewCtl ()
{
    MBProgressHUD *_HUD;
}

@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray *shopList;
@end

@implementation MyIntegralTableViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped target:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[MyIntegralCell class] forCellReuseIdentifier:@"MyIntegralCell"];
    
    [self addRefreshView];
    
    self.currentPage = 0;
    [self loadShopList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help methods
- (void)loadShopList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserShoplistURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getShoplist >>>>>>>>>>> %@",dataBack);
        if (self.currentPage == 0) {
            [self.shopList removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Shop *shop = [[Shop alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error ====== %@",error);
                }
                [self.shopList addObject:shop];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            [self.parentViewController showHudMessage:@"你还没有兑换信息!"];
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
    __weak MyIntegralTableViewCtl *myIntegral = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        myIntegral.currentPage = 0;
        [myIntegral loadShopList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        myIntegral.currentPage ++;
        [myIntegral loadShopList];
    }];
    //[self hideRefreshViewsubViews:self.tableView];
}

#pragma mark - 懒加载
- (NSMutableArray *)shopList
{
    if (_shopList == nil) {
        _shopList = [NSMutableArray array];
    }
    return _shopList;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
    Shop *shop = self.shopList[indexPath.row];
    ExchangeViewCtl *exchange = [[ExchangeViewCtl alloc] init];
    exchange.shop = shop;
    [exchange setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:exchange animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIntegralCell"];
    Shop *shop = self.shopList[indexPath.row];
    [cell configCellWithModel:shop];
    return cell;
}


@end
