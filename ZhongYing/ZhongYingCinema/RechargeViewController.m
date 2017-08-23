//
//  RechargeViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/17.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "RechargeViewController.h"
#import "DataConnect.h"
#import "RechargeModel.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface RechargeViewController ()<UIScrollViewDelegate,WXApiDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *_rechargeContentView;
    UIView *_rechargeChooseView;
    UILabel *_balanceLb;
    UITextField *_moneyTextField;
    NSMutableArray *_chooseArr;
    UIWebView *_protocolWV;
    UIButton *_sureBtn;
    MBProgressHUD *_rechargeHUD;
    NSString *_orderfrom_id; //!<< 订单id
    MBProgressHUD *_HUD;
}
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"充值";
    
    // 充值余额支付宝回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAlipayProcessFromRecharge:) name:@"getAlipayProcessFromRecharge" object:nil];
    // 微信支付回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWXPayProcessFromPayment:) name:@"WXPay_BuyTicket_Success" object:nil];
    
    _scrollView = [UIViewController createScrollView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [_scrollView addGestureRecognizer:tap];
    _scrollView.backgroundColor = Color(242, 242, 242, 1.0);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _rechargeContentView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 100) backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_rechargeContentView];
    
    _rechargeChooseView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 115, ScreenWidth, 100) backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_rechargeChooseView];
    
    [self initRechargeUI];
    
    _chooseArr = [NSMutableArray array];
    DataConnect *connect = [DataConnect shareInstance];
    [connect createRechargeArr:@[@"微信支付",@"支付宝支付"] ToResultArr:^(id dataBack) {
        if (dataBack) {
            [_chooseArr addObjectsFromArray:dataBack];
            [self createChooseWithArr:_chooseArr];
        }
    }];
    
    // 提示
//    NSString *tipStr = @"注：";
//    CGSize tipSize = [FanShuToolClass createString:tipStr font:[UIFont systemFontOfSize:16] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth/2, 50)];
//    UILabel *tipLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 230, tipSize.width, tipSize.height) text:tipStr font:[UIFont systemFontOfSize:16] textColor:[UIColor redColor] alignment:NSTextAlignmentLeft];
//    [_scrollView addSubview:tipLb];
    
//    NSString *prompStr = @"在2016-08-06至2016-08-08期间，凡在本平台进行充值的用户，都可以享受充值送多少送50%的优惠活动。";
//    CGSize prompSize = [FanShuToolClass createString:prompStr font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth-40-tipSize.width, 100)];
//    _promptLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20+tipSize.width, 230, ScreenWidth-40-tipSize.width, prompSize.height) text:prompStr font:[UIFont systemFontOfSize:16] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
//    _promptLb.numberOfLines = 0;
//    _promptLb.attributedText = [FanShuToolClass getAttributeStringWithContent:prompStr withLineSpaceing:3];
//    [_scrollView addSubview:_promptLb];
    _protocolWV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 215, ScreenWidth, ScreenHeight)];
    _protocolWV.delegate = self;
    _protocolWV.scrollView.bounces = NO;
    _protocolWV.scrollView.showsHorizontalScrollIndicator = NO;
    _protocolWV.scrollView.scrollEnabled = NO;
    [_scrollView addSubview:_protocolWV];
    
    // 确认
    UIButton *sureBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, ScreenHeight-180, ScreenWidth-30, 50) title:@"确认" titleColor:[UIColor whiteColor] target:self action:@selector(gotoRechargeEvent:) tag:10000];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4.0f;
    _sureBtn = sureBtn;
    [_scrollView addSubview:sureBtn];
    
    _sureBtn.enabled = YES;
    _sureBtn.backgroundColor = COLOR_NAVAAR;
    
    [self loadChargeExplain];
}

- (void)initRechargeUI{
    NSArray *contentArr = @[@"账户余额：",@"金额："];
    for (int i=0; i<contentArr.count; i++) {
        CGSize leftSize = [FanShuToolClass createString:contentArr[i] font:[UIFont systemFontOfSize:17] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth/2, 50)];
        UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 50*i, leftSize.width, 50) text:contentArr[i] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [_rechargeContentView addSubview:leftLb];
        
        if (i == 0) {
            _balanceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20+leftSize.width, 50*i, ScreenWidth-40-leftSize.width, 50) text:[NSString stringWithFormat:@"%@元",ApiMyRemainStr] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
            [_rechargeContentView addSubview:_balanceLb];
            
            UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 49.5, ScreenWidth, 0.5f) backgroundColor:[UIColor lightGrayColor]];
            [_rechargeContentView addSubview:lineView];
        }else {
            // 金额
            _moneyTextField = [FanShuToolClass createTextFieldWithFrame:CGRectMake(20+leftSize.width, 50*i, ScreenWidth-40-leftSize.width, 50) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17] target:self];
            [_moneyTextField addTarget:self action:@selector(gotoTextFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
            _moneyTextField.backgroundColor = [UIColor whiteColor];
            _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
            _moneyTextField.textAlignment = NSTextAlignmentLeft;
            _moneyTextField.placeholder = @"请输入充值金额";
            [_rechargeContentView addSubview:_moneyTextField];
        }
    }
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

- (void)loadChargeExplain
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserChargeExplainURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getChargeExplain >>>>>>>> %@",dataBack);
        [_HUD hide:YES];
        NSDictionary *content = dataBack[@"content"];
        if ([dataBack[@"code"] integerValue] == 0) {
            [_protocolWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,content[@"url"]]]]];
        }else{
            //[self showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败！"];
        [_HUD hide:YES];
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_HUD hide:YES];
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] integerValue];
    _protocolWV.frame=CGRectMake(0, 215, ScreenWidth, height);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && [alertView.message isEqualToString:@"支付结果：成功!"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getAlipayProcessFromRecharge
- (void)getAlipayProcessFromRecharge:(NSNotification *)note
{
    NSDictionary *result = note.object;
    if ([result[@"resultStatus"] integerValue] == 9000) {
        // 上传支付宝回调到服务器
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserRechargeAlipayValidaURL];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        parameters[@"orderform_id"] = _orderfrom_id;
        parameters[@"content"] = result[@"result"];
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            NSLog(@"服务器验证支付宝结果>>>>>>>>>>>>>>>%@",dataBack);
            NSDictionary *content = dataBack[@"content"];
            if ([dataBack[@"code"] integerValue] == 0) {
                if (content[@"result"]) {
                    [self showAlertTitle:@"支付结果" message:@"支付结果：成功!"];
                }
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
        } failure:^(NSError *error) {
            [self showHudMessage:@"连接服务器失败!"];
        }];
    }else if([result[@"resultStatus"] integerValue] == 6001){
        [self showAlertTitle:@"" message:@"用户取消了支付"];
    }else if ([result[@"resultStatus"] integerValue] == 4000){
        [self showAlertTitle:@"支付结果" message:@"支付结果：失败!"];
    }else{
        [self showHudMessage:result[@"memo"]];
    }
}

- (void)getWXPayProcessFromPayment:(NSNotification *)note
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 微信支付、支付宝支付
- (void)createChooseWithArr:(NSMutableArray *)arr{
    for (UIView *view in _rechargeChooseView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *imageArr = @[@"Recharge_weChat",@"Recharge_alipay"];
    for (int i=0; i<arr.count; i++) {
        RechargeModel *model = arr[i];
        UIView *backView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 50*i, ScreenWidth, 50) backgroundColor:[UIColor whiteColor]];
        backView.tag = 100+i;
        [_rechargeChooseView addSubview:backView];
        
        UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 49.5, ScreenWidth, 0.5f) backgroundColor:[UIColor lightGrayColor]];
        [backView addSubview:lineView];
        
        UIImageView *leftImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(20, 10, 30, 30) image:[UIImage imageNamed:imageArr[i]] tag:1000+i];
        [backView addSubview:leftImg];
        
        UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(60, 0, 100, 50) text:model.chooseStr font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [backView addSubview:leftLb];
        
        UIImageView *rightImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-40, 13, 24, 24) image:[UIImage imageNamed:@"Recharge_white"] tag:1002+i];
        [backView addSubview:rightImg];
        
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rechargeTapClick:)];
        [backView addGestureRecognizer:backTap];
        
        if (model.isOpen == YES) {
            rightImg.image = [UIImage imageNamed:@"Recharge_green"];
        }else {
            rightImg.image = [UIImage imageNamed:@"Recharge_white"];
        }
    }
}

- (void)gotoTextFieldValueChange:(UITextField *)fld
{
    if ([fld.text length] != 0) {
        _sureBtn.enabled = YES;
        _sureBtn.backgroundColor = COLOR_NAVAAR;
    }else{
        _sureBtn.enabled = YES;
        _sureBtn.backgroundColor = COLOR_NAVAAR;
    }
}

- (void)rechargeTapClick:(UITapGestureRecognizer *)tap{
    for (int i= 0; i<_chooseArr.count; i++) {
        if (i == tap.view.tag - 100) {
            RechargeModel *model = _chooseArr[tap.view.tag - 100];
            model.isOpen = YES;
        }else {
            RechargeModel *model = _chooseArr[i];
            model.isOpen = NO;
        }
    }
    [self createChooseWithArr:_chooseArr];
}

- (void)goUserRechargeWithType:(NSInteger)type
{
    _rechargeHUD = [FanShuToolClass createMBProgressHUDWithText:@"确认充值中..." target:self];
    [self.view addSubview:_rechargeHUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserRechargeURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"money"] = @([_moneyTextField.text floatValue]);
    parameters[@"type"] = @(type);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getUserRecharge>>>>>>>>>>>>>>%@",dataBack);
        NSDictionary *content = dataBack[@"content"];
        if ([dataBack[@"code"] integerValue] == 0) {
            if (type == 1) { //支付宝
                _orderfrom_id = content[@"orderform_id"];
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isProcessFromPayment"];
                [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",content[@"alipay_content"]] fromScheme:@"Ali2017020905586156" callback:^(NSDictionary *resultDic) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAlipayProcessFromRecharge" object:resultDic];
                }];
            }else{  // 微信
                if ([WXApi isWXAppInstalled]) {  //检查微信是否已被用户安装
                    NSString *res = [WXApiRequestHandler jumpToBizPayContent:content];
                    if( ![@"" isEqual:res] ){
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alter show];
                    }
                }else{
                    [self showHudMessage:@"你还没有安装微信客户端"];
                }
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_rechargeHUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_rechargeHUD hide:YES];
    }];
}

- (void)gotoRechargeEvent:(UIButton *)btn{
    if (btn.tag == 10000) {
        if ([_moneyTextField.text isEqualToString:@""]) {
            [self showHudMessage:@"请输入充值金额!"];
        }else if (!([_moneyTextField.text integerValue] >=10 && [_moneyTextField.text integerValue] <= 10000)){
            [self showHudMessage:@"充值范围为10-10000元!"];
        }else{
            RechargeModel *model = _chooseArr[0];
            if (model.isOpen) { // 微信支付
                NSLog(@"微信支付");
                [self goUserRechargeWithType:2];
            }else{  // 支付宝支付
                NSLog(@"支付宝支付");
                [self goUserRechargeWithType:1];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)closeKeyBoard
{
    [_moneyTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text length]< 5) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_moneyTextField resignFirstResponder];
}

@end
