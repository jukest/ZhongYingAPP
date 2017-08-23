//
//  BillDetailsViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/6.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "BillDetailsViewCtl.h"

@interface BillDetailsViewCtl ()
{
    MBProgressHUD *_HUD;
    UIView *_ticketView;
}
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *billImg;
@property(nonatomic,strong) UILabel *priceLb;
@property(nonatomic,strong) NSDictionary *detail;
@property(nonatomic,strong) NSMutableArray *contents;

@end

@implementation BillDetailsViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"账单详情";
    
    self.scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -63) target:self];
    self.scrollView.backgroundColor = Color(245, 245, 249, 1.0);
    [self.view addSubview:self.scrollView];
    
    [self initHeaderUI];
    
    
    NSArray *title = @[@[@"影片：",@"影院：",@"消费时间"],@[@"商品：",@"影院：",@"消费时间："],@[@"付款方式：",@"操作时间："],@[@"影院：",@"影片：",@"原价：",@"手续费：",@"操作时间："],@[@"影院：",@"套餐：",@"原价：",@"手续费：",@"操作时间："],@[@"付款方式：",@"操作时间："]];
    [self initTicketBillUIWithTitles:title[self.bill.operate_type -1]];
    [self loadBillDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)contents
{
    if (_contents == nil) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}

- (void)initHeaderUI
{
    UIView *headerView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 150) backgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:headerView];
    NSArray *arr = @[@"bill_ticket",@"bill_package",@"bill_recharge",@"bill_refund"];
    NSString *img;
    switch (self.bill.operate_type) {
        case 1: // 电影票
            img = arr[0];
            break;
        case 2: // 卖品
            img = arr[1];
            break;
        case 3: // 充值
            img = arr[2];
            break;
        case 4: // 退票
            img = arr[3];
            break;
        case 5: // 退货
            img = arr[3];
            break;
        case 6: // 手续费
            img = arr[3];
            break;
        default:
            break;
    }
    self.billImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(15 +40 +15, 6, 60, 60) image:[UIImage imageNamed:img] tag:34];
    self.billImg.center = CGPointMake(ScreenWidth / 2, 18 +30);
    self.billImg.layer.cornerRadius = 25;
    self.billImg.clipsToBounds = YES;
    [headerView addSubview:self.billImg];
    
    NSString *price;
    if (self.bill.type == 1) {
        price = [NSString stringWithFormat:@"-%.2f",self.bill.balance * 1.0];
    }else{
        price = [NSString stringWithFormat:@"+%.2f",self.bill.balance * 1.0];
    }
    self.priceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 300, 30) text:price font:[UIFont systemFontOfSize:30] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.priceLb.center = CGPointMake(ScreenWidth / 2, 18 +60 +25 +15);
    [headerView addSubview:self.priceLb];
}

- (void)loadBillDetails
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserBillDetailURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"id"] = @(self.bill.id);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getBillDetail >>>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            self.detail = dataBack[@"content"][@"detail"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self configArray];
        [self configContentWithContent:self.contents];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)configArray
{
    switch (self.bill.operate_type) {
        case 1: // 电影票
        {
            [self.contents addObject:self.detail[@"name"]];
            [self.contents addObject:self.detail[@"cinema_name"]];
            [self.contents addObject:[[NSString stringWithFormat:@"%@",self.detail[@"created_time"]] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
            break;
        case 2: // 卖品
        {
            [self.contents addObject:self.detail[@"name"]];
            [self.contents addObject:self.detail[@"cinema_name"]];
            [self.contents addObject:[[NSString stringWithFormat:@"%@",self.detail[@"created_time"]] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
            break;
        case 3: // 充值
        {
            if ([self.detail[@"balance_type"] intValue] == 1) {
                [self.contents addObject:@"支付宝"];
            }else{
                [self.contents addObject:@"微信"];
            }
            [self.contents addObject:[[NSString stringWithFormat:@"%@",self.detail[@"created_time"]] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
            break;
        case 4: // 退票
        {
            [self.contents addObject:self.detail[@"cinema_name"]];
            [self.contents addObject:self.detail[@"name"]];
            [self.contents addObject:[NSString stringWithFormat:@"%.2f元",[self.detail[@"original_price"] floatValue]]];
            [self.contents addObject:[NSString stringWithFormat:@"%.2f元",[self.detail[@"poundage"] floatValue]]];
            [self.contents addObject:[[NSString stringWithFormat:@"%@",self.detail[@"created_time"]] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
            break;
        case 5: // 退货
        {
            [self.contents addObject:self.detail[@"cinema_name"]];
            [self.contents addObject:self.detail[@"name"]];
            [self.contents addObject:[NSString stringWithFormat:@"%.2f元",[self.detail[@"original_price"] floatValue]]];
            [self.contents addObject:[NSString stringWithFormat:@"%.2f元",[self.detail[@"poundage"] floatValue]]];
            [self.contents addObject:[[NSString stringWithFormat:@"%@",self.detail[@"created_time"]] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
            break;
        case 6: // 手续费
        {
            [self.contents addObject:@"退票-电影票"];
            [self.contents addObject:[[NSString stringWithFormat:@"%@",self.detail[@"created_time"]] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
            break;
        default:
            break;
    }
}

- (void)initTicketBillUIWithTitles:(NSArray *)title
{
    _ticketView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 150, ScreenWidth, title.count * 17 +(title.count -1) * 16 +10) backgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:_ticketView];
    for (int i = 0; i < title.count; i ++) {
        UILabel *titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, i *33, 150, 17) text:title[i] font:[UIFont systemFontOfSize:16] textColor:Color(25, 25, 25, 1.0) alignment:NSTextAlignmentLeft];
        [_ticketView addSubview:titleLb];
    }
}

- (void)configContentWithContent:(NSArray *)content
{
    for (int i = 0; i < content.count; i ++) {
        
        UILabel *contentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -12 -200, i *33, 200, 17) text:content[i] font:[UIFont systemFontOfSize:16] textColor:Color(25, 25, 25, 1.0) alignment:NSTextAlignmentRight];
        [_ticketView addSubview:contentLb];
    }
}

@end
