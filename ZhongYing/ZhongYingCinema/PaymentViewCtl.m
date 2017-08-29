//
//  PaymentViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/1.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "PaymentViewCtl.h"
#import "PaymentTableViewCell.h"
#import "PaymentView.h"
#import "MyOrderViewCtl.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface PaymentViewCtl ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    PaymentView *_headerView;
    NSIndexPath *_index;
    MBProgressHUD *_HUD;
    MBProgressHUD *_payHUD;
    float _remain;
}

@property(nonatomic,strong) NSMutableDictionary *order;
@property(nonatomic,strong) NSMutableArray *packageList;

@end

@implementation PaymentViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"支付订单";
    _index = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // 支付宝支付回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAlipayProcessFromPayment:) name:@"getAlipayProcessFromPayment" object:nil];
    // 微信支付回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWXPayProcessFromPayment:) name:@"WXPay_BuyTicket_Success" object:nil];
    
    if (self.orderform_id != nil) {
        [self loadOrderInfo];
    }
    else{
        [self loadGoodsOrder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help methods
- (void)loadOrderInfo
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserOrderInfoURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"orderform_id"] = self.orderform_id;
    parameters[@"coupon_id"] = self.coupon_id;
    parameters[@"seat_id"] = self.seat_id;
    parameters[@"film_id"] = @(self.film_id);
    parameters[@"goods"] = self.goods;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getOrderInfo>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            _remain = [content[@"remain"] floatValue];
            self.order = [NSMutableDictionary dictionary];
            self.order[@"price"] = content[@"price"];
            self.order [@"name"] = content[@"order_info"][0][@"name"];
            self.order[@"cover"] = content[@"order_info"][0][@"cover"];
            self.order[@"forHuman"] = content[@"order_info"][0][@"forHuman"];
            self.order[@"hall"] = content[@"order_info"][0][@"hall"];
            self.order[@"hall_type"] = content[@"order_info"][0][@"hall_type"];
            self.order[@"tag"] = content[@"order_info"][0][@"tag"];
            self.order[@"type"] = content[@"order_info"][0][@"type"];
            self.order[@"orderform_id"] = content[@"orderform_id"];
            self.order[@"coupon_id"] = content[@"coupon_id"];
            self.order[@"seats"] = self.seats;
            for (NSInteger i = 1; i < [content[@"order_info"] count]; i ++) {
                NSDictionary *dict = content[@"order_info"][i];
                [self.packageList addObject:dict];
            }
            [self setupPaymentHeaderView];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [_HUD hideAnimated:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)loadGoodsOrder
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserGoodsOrderURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    if (self.coupon_id != nil) {
        parameters[@"coupon_id"] = self.coupon_id;
    }
    parameters[@"goods_info"] = self.goods;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getGoodsOrder>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            if (![content[@"goods_order"][@"remain"] isEqual:[NSNull null]]) {
                _remain = [content[@"goods_order"][@"remain"] floatValue];
            }else{
                _remain = 0;
            }
            self.order = [NSMutableDictionary dictionary];
            self.order[@"price"] = content[@"goods_order"][@"last_price"];
            self.order [@"name"] = content[@"goods_order"][@"name"];
            self.order[@"cover"] = content[@"goods_order"][@"images"];
            self.order[@"orderform_id"] = content[@"goods_order"][@"order_id"];
            self.order[@"coupon_id"] = content[@"goods_order"][@"coupon_id"];
            self.order[@"number"] = content[@"goods_order"][@"number"];
            //for (NSInteger i = 1; i < [content[@"goods_order"] count]; i ++) {
                NSDictionary *dict = content[@"goods_order"];
                NSMutableDictionary *pack = [NSMutableDictionary dictionary];
                pack[@"name"] = [NSString stringWithFormat:@"￥%@",dict[@"last_price"]];
                pack[@"detail"] = dict[@"name"];
                [self.packageList addObject:pack];
            //}
            [self setupPaymentHeaderView];
        }else{
            if (![dataBack[@"message"] isEqual:[NSNull null]]) {
                [self showHudMessage:dataBack[@"message"]];
            }
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [_HUD hide:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)payOrderWithPayType:(NSInteger)type
{
    if (type == 1) { // 余额支付
        if (_remain == 0) {
            [self showHudMessage:@"当前余额为0，请充值再购买！"];
            return;
        }
        if (_remain < [self.order[@"price"] floatValue]) {
            [self showHudMessage:@"当前余额不足，请充值再购买！"];
            return;
        }
    }
    _payHUD = [FanShuToolClass createMBProgressHUDWithText:@"支付订单中..." target:self];
    [self.view addSubview:_payHUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserPayOrderURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    if (self.orderform_id != nil) {
        parameters[@"orderform_id"] = [self.order[@"orderform_id"] componentsJoinedByString:@","];
        parameters[@"coupon_id"] = [self.order[@"coupon_id"] componentsJoinedByString:@","];
    }else{
        parameters[@"orderform_id"] = self.order[@"orderform_id"];
        parameters[@"coupon_id"] = self.order[@"coupon_id"];
    }
    
    parameters[@"type"] = @(type);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            if (type == 1) { // 余额
                if ([content[@"result"] boolValue]) {
                    [self showHudMessage:@"支付成功!"];
                    //保存订单状态
                    [self saveOrderStatus];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MyOrderViewCtl *order = [[MyOrderViewCtl alloc] init];
                        order.isFromPayMent = YES;
                        [self.navigationController pushViewController:order animated:YES];
                    });
                }else{
                    [self showHudMessage:content[@"info"]];
                }
            }else if (type == 3){  // 微信
                if ([WXApi isWXAppInstalled]) {  //检查微信是否已被用户安装
                    NSString *res = [WXApiRequestHandler jumpToBizPayContent:content];
                    if( ![@"" isEqual:res] ){
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alter show];
                    }
                }
            }else{ // 支付宝
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isProcessFromPayment"];
                [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",content[@"alipay_content"]] fromScheme:@"Ali2017020905586156" callback:^(NSDictionary *resultDic) {
                    NSLog(@"支付宝结果回调>>>>>>>>>>>>>>>>>>>>>%@",resultDic);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAlipayProcessFromPayment" object:resultDic];
                }];
            }
            [_payHUD hide:YES];
        }else{
            [self showHudMessage:dataBack[@"message"]];
            [_payHUD hide:YES];
        }
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_payHUD hide:YES];
    }];
}

- (void)saveOrderStatus
{
    if (self.isTicket) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isOrderForTicket"];
    }
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && [alertView.message isEqualToString:@"支付结果：成功!"]) {
        MyOrderViewCtl *order = [[MyOrderViewCtl alloc] init];
        order.isFromPayMent = YES;
        [self.navigationController pushViewController:order animated:YES];
    }
}

#pragma mark - getAlipayProcessFromPayment
- (void)getAlipayProcessFromPayment:(NSNotification *)note
{
    [_payHUD show:YES];
    NSDictionary *result = note.object;
    if ([result[@"resultStatus"] integerValue] == 9000) {
        // 上传支付宝购买回调到服务器
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserAlipayValidaURL];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        if (self.orderform_id != nil) {
            parameters[@"orderform_id"] = [self.order[@"orderform_id"] componentsJoinedByString:@","];
            parameters[@"conpon_id"] = [self.order[@"coupon_id"] componentsJoinedByString:@","];
        }else{
            parameters[@"orderform_id"] = self.order[@"orderform_id"];
            parameters[@"conpon_id"] = self.order[@"coupon_id"];
        }
        parameters[@"content"] = result[@"result"];
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            NSLog(@"服务器验证支付宝结果>>>>>>>>>>>>>>>%@",dataBack);
            NSDictionary *content = dataBack[@"content"];
            if ([dataBack[@"code"] integerValue] == 0) {
                if (content[@"result"]) {
                    [self saveOrderStatus];
                    [self showAlertTitle:@"支付结果" message:@"支付结果：成功!"];
                }
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
        } failure:^(NSError *error) {
            [self showHudMessage:@"连接服务器失败!"];
        }];
        [_payHUD hide: YES];
    }else if([result[@"resultStatus"] integerValue] == 6001){
        [self showAlertTitle:@"" message:@"用户取消了支付!"];
        [_payHUD hide: YES];
    }else if ([result[@"resultStatus"] integerValue] == 4000){
        [self showAlertTitle:@"支付结果" message:@"支付结果：失败!"];
        [_payHUD hide: YES];
    }else{
        [self showHudMessage:result[@"memo"]];
        [_payHUD hide: YES];
    }
}

- (void)getWXPayProcessFromPayment:(NSNotification *)note
{
    [self saveOrderStatus];
    MyOrderViewCtl *order = [[MyOrderViewCtl alloc] init];
    order.isFromPayMent = YES;
    [self.navigationController pushViewController:order animated:YES];
}

#pragma mark - view handle
- (void)gotoPaymentEvents:(UIButton *)btn
{
    if (_index) {
        if (_index.row == 0) {
            NSLog(@"余额支付");
            [self payOrderWithPayType:1];
        }else if (_index.row == 1){
            NSLog(@"微信支付");
            //[WXApiRequestHandler jumpToBizPay];
            [self payOrderWithPayType:3];
        }else if (_index.row == 2){
            NSLog(@"支付宝支付");
            
            [self payOrderWithPayType:2];
        }
    }else{
        NSLog(@"请选择支付方式");
    }
}

- (void)setupPaymentHeaderView
{
    float height = 0;
    PaymentShowMessage type = PaymentShowMovieMessage;
    if (self.orderform_id == nil) {
        height = -131;
        type = PaymentNotShowMovieMessage;
    }
    _headerView = [[PaymentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130 + height + 65 * self.packageList.count) type:type packageArr:self.packageList movieMessage:self.order];
    self.paymentTableView.tableHeaderView = _headerView;
    
    //[_headerView configPaymentHeaderViewWithInfo:self.order];
    CGFloat footerH = (ScreenHeight -64 > (_headerView.frame.size.height+19 +19 +3 *50 +110)) ? (ScreenHeight -64 - (_headerView.frame.size.height+19 +19 +3 *50)) : (19 + 110);
    UIView *footer = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, footerH) backgroundColor:[UIColor clearColor]];
    UIButton *confirmBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12, footer.frame.size.height -110, ScreenWidth -24, 55) title:@"确认支付" titleColor:[UIColor whiteColor] target:self action:@selector(gotoPaymentEvents:) tag:10002];
    confirmBtn.layer.cornerRadius = 5.0;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    confirmBtn.backgroundColor = Color(252, 186, 0, 1.0);
    [footer addSubview:confirmBtn];
    self.paymentTableView.tableFooterView = footer;
}

#pragma mark - 懒加载
- (UITableView *)paymentTableView
{
    if (_paymentTableView == nil) {
        _paymentTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_paymentTableView registerClass:[PaymentTableViewCell class] forCellReuseIdentifier:@"PaymentTableViewCell"];
        [self.view addSubview:_paymentTableView];
    }
    return _paymentTableView;
}

- (NSMutableArray *)packageList
{
    if (_packageList == nil) {
        _packageList = [NSMutableArray array];
    }
    return _packageList;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 19;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectbtn.selected = YES;
    _index = indexPath;
    [self.paymentTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = @[@"账户余额支付",@"微信支付",@"支付宝支付"];
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTableViewCell"];
    [cell configCellWithRemain:_remain];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"payment_icon_%zd",indexPath.row +1]];
    cell.titleLb.text = arr[indexPath.row];
    if (indexPath.row != 0) {
        cell.balanceLb.hidden = YES;
    }else{
        cell.balanceLb.hidden = NO;
    }
    if (_index && indexPath.section == _index.section && indexPath.row == _index.row) {
        cell.selectbtn.selected = YES;
    }else{
        cell.selectbtn.selected = NO;
    }
    return cell;
}

@end
