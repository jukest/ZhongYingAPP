//
//  NoTicketTableViewCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/18.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "NoTicketTableViewCtl.h"
#import "NoTicketCell.h"
#import "OrderDetailsCtl.h"
#import "RefundView.h"
#import "Order.h"
#import <WebKit/WKWebView.h>

@interface NoTicketTableViewCtl ()<NoticketCellDelegate,RefundViewDelegate,UIWebViewDelegate>
{
    MBProgressHUD *_HUD;
    MBProgressHUD *_refundHUD;
    UIWebView *_webView;
    NSIndexPath *_refundIndex;
}

@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray *orders;
@property(nonatomic,copy) NSString *url;

@property(nonatomic, assign) BOOL allowRefunds;
@end

@implementation NoTicketTableViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = Color(245, 245, 245, 1.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoTicketCell class] forCellReuseIdentifier:@"NoTicketCell"];
    [self addRefreshView];
    self.currentPage = 0;
    
    [self createTableFooterView];
    [self loadOrderformList];
}

- (void)createTableFooterView{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 20, ScreenWidth -24, 160)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_HUD hide:YES];
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] integerValue];
    _webView.frame=CGRectMake(12, 20, ScreenWidth -24, height);
    
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, height +20) backgroundColor:[UIColor whiteColor]];
    UIView *view1 = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 20) backgroundColor:Color(245, 245, 245, 1.0)];
    [view addSubview:view1];
    [view addSubview:_webView];
    
    self.tableView.tableFooterView =  view;
}

#pragma mark - help methods
- (void)loadOrderformList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserOrderformListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getOrderformList >>>>>>>>>>> %@",dataBack);
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
            if (self.url == nil) {
                self.url = content[@"url"];
                [self.tableView reloadData];
                if (self.url != nil) {
                    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.url]]]];
                    [_HUD hideAnimated:YES];
                }else{
                    [_HUD hideAnimated:YES];
                }
            }else{
                [self.tableView reloadData];
                [_HUD hideAnimated:YES];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (self.currentPage == 0) {
                [self.parentViewController showHudMessage:@"你还没有订单信息!"];
                [self.tableView reloadData];
                [_HUD hideAnimated:YES];
            }else{
                [self.parentViewController showHudMessage:@"没有订单了!"];
            }
            [_HUD hideAnimated:YES];
        }else{
            [self.parentViewController showHudMessage:dataBack[@"message"]];
            [_HUD hideAnimated:YES];
        }
        
        [self hideRefreshView];
    } failure:^(NSError *error) {
        [self.parentViewController showHudMessage:@"连接服务器失败!"];
        [self hideRefreshView];
        [_HUD hideAnimated:YES];
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
    __weak NoTicketTableViewCtl *noTicetk = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        noTicetk.currentPage = 0;
        [noTicetk loadOrderformList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        noTicetk.currentPage ++;
        [noTicetk loadOrderformList];
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

#pragma mark - NoticketCellDelegate
- (void)gotoRefundEventIndexPath:(NSIndexPath *)index
{
    
    _refundIndex = index;
    NSString *content;
    NSString *notAllowRefundsStr = @"感谢您购买本影城电影票，电影即将放映，现不支持退票，谢谢合作！";

     Order *order = self.orders[_refundIndex.row];
    if ([order.orderform_type integerValue] == 1) {
        
        
        NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval interval =[order.time doubleValue] - currentInterval;
        int hours = (int)interval / 3600;//计算距离开场还有多少小时
        int secondes = (int)interval % 3600;//计算距离开场还有 hours secondes秒
        if (hours > 3) {//允许退票
            self.allowRefunds = YES;
            content = [NSString stringWithFormat:@"欢迎您来到本影院观赏电影，您购买的“%@”电影票将进行退票处理，退票金额将返还到您的账户余额，请注意查看，谢谢!",order.name];
        } else if (hours == 3) {//判断是否还有多余的时间
            
            if (secondes > 0) {//允许退票
                content = [NSString stringWithFormat:@"欢迎您来到本影院观赏电影，您购买的“%@”电影票将进行退票处理，退票金额将返还到您的账户余额，请注意查看，谢谢!",order.name];
                self.allowRefunds = YES;
            } else {//不允许退票
                self.allowRefunds = NO;
                content = [NSString stringWithFormat:@"%@",notAllowRefundsStr];
            }
            
        } else { //不允许退票
            self.allowRefunds = NO;
            content = [NSString stringWithFormat:@"%@",notAllowRefundsStr];
        }
        
    }else{
        content = [NSString stringWithFormat:@"欢迎您来到本影院观赏电影，您购买的“%@”套餐将进行退货处理，退货金额将返还到您的账户余额，请注意查看，谢谢!",order.detail];
    }
    CGSize contentSize = [FanShuToolClass createString:content font:[UIFont systemFontOfSize:16] lineSpacing:7 maxSize:CGSizeMake(ScreenWidth -30 -46, ScreenHeight)];
    RefundView *refund = [[RefundView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth -60, 112 +contentSize.height+20) WithContent:content];
    refund.delegate = self;
    [refund show];
}

#pragma mark - RefundViewDelegate
- (void)gotoRefundViewEvents:(NSInteger)tag
{
    if (self.allowRefunds) {
        
    } else {
        
        return;
    }
    
    if (tag == 101) {
        NSLog(@"确定");
        Order *order = self.orders[_refundIndex.row];
        NSString *message;
        NSString *result;
        if ([order.orderform_type integerValue] == 1) {
            message = @"退票中...";
            result = @"退票成功";
        }else{
            message = @"退货中...";
            result = @"退货成功";
        }
        _refundHUD = [FanShuToolClass createMBProgressHUDWithText:message target:self];
        [self.view addSubview:_refundHUD];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserReturnOrderURL];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        parameters[@"orderform_id"] = order.orderform_id;
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            NSLog(@"getreturnOrderResult >>>>>>>>>>>>>>>>> %@",dataBack);
            if ([dataBack[@"code"] integerValue] == 0) {
                NSDictionary *content = dataBack[@"content"];
                if ([content[@"result"] boolValue]) {
                    [self.parentViewController showHudMessage:content[@"info"]];
                }else{
                    [self.parentViewController showHudMessage:content[@"info"]];
                }
                [self.orders removeObject:order];
                [self.tableView reloadData];
            }else{
                [self.parentViewController showHudMessage:dataBack[@"message"]];
            }
            [_refundHUD hideAnimated:YES];
        } failure:^(NSError *error) {
            [self.parentViewController showHudMessage:@"连接服务器失败!"];
            [_refundHUD hideAnimated:YES];
        }];
    }
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
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Order *order = self.orders[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailsCtl *orderDetails = [[OrderDetailsCtl alloc] init];
    orderDetails.order = order;
    [self.navigationController pushViewController:orderDetails animated:YES];
}

@end
