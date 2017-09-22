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

#define sectionHeight 35
#define marge 10

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

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray <UIButton *>*sectionButtons;

@property (nonatomic, strong) UIButton *userSelectedBtn;
@end

@implementation RechargeViewController

- (NSMutableArray<UIButton *> *)sectionButtons {
    if (!_sectionButtons) {
        _sectionButtons = [NSMutableArray array];
    }
    return _sectionButtons;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"充值";
    
    // 充值余额支付宝回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAlipayProcessFromRecharge:) name:@"getAlipayProcessFromRecharge" object:nil];
    // 微信支付回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWXPayProcessFromPayment:) name:@"WXPay_BuyTicket_Success" object:nil];
    
    
    [self loadChargeExplain];
    
    //加载充值范围
    [self loadRechargeRange];
}

- (void)setupUI {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -  64)];
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [_scrollView addGestureRecognizer:tap];
    _scrollView.backgroundColor = Color(242, 242, 242, 1.0);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    int count = self.sectionArray.count % 3 == 0 ? ((int)self.sectionArray.count / 3) : ((int)self.sectionArray.count / 3 + 1);
    CGFloat countH = count*sectionHeight + count * marge;
    _rechargeContentView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 70 + countH ) backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_rechargeContentView];
    
    CGFloat y = CGRectGetMaxY(_rechargeContentView.frame) + 10;
    _rechargeChooseView = [FanShuToolClass createViewWithFrame:CGRectMake(0, y, ScreenWidth, 100) backgroundColor:[UIColor whiteColor]];
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
    
    y = CGRectGetMaxY(_rechargeChooseView.frame);
    _protocolWV = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight)];
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
}

- (void)initRechargeUI{
    NSArray *contentArr = @[@"账户余额：",@"选择金额"];
    for (int i=0; i<contentArr.count; i++) {
        CGSize leftSize = [FanShuToolClass createString:contentArr[i] font:[UIFont systemFontOfSize:17] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth/2, 50)];
        
        
        if (i == 0) {
            
            UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 50*i, leftSize.width, 50) text:contentArr[i] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
            [_rechargeContentView addSubview:leftLb];
            
            _balanceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20+leftSize.width, 50*i, ScreenWidth-40-leftSize.width, 50) text:[NSString stringWithFormat:@"%@元",ApiMyRemainStr] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
            [_rechargeContentView addSubview:_balanceLb];
            
            UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 49.5, ScreenWidth, 0.5f) backgroundColor:[UIColor lightGrayColor]];
            [_rechargeContentView addSubview:lineView];
        }else {
            
            UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 50*i, leftSize.width, 20) text:contentArr[i] font:[UIFont systemFontOfSize:14] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentLeft];
            [_rechargeContentView addSubview:leftLb];
            
//            // 金额
//            _moneyTextField = [FanShuToolClass createTextFieldWithFrame:CGRectMake(20+leftSize.width, 50*i, ScreenWidth-40-leftSize.width, 50) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17] target:self];
//            [_moneyTextField addTarget:self action:@selector(gotoTextFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
//            _moneyTextField.backgroundColor = [UIColor whiteColor];
//            _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
//            _moneyTextField.textAlignment = NSTextAlignmentLeft;
//            _moneyTextField.placeholder = @"请选择充值金额";
//            [_rechargeContentView addSubview:_moneyTextField];
        }
    }
    
    
   
    
    CGFloat sectionWidth = (ScreenWidth - 4 * marge) / 3;
    CGFloat y = CGRectGetMaxY(_balanceLb.frame) + 20;
    for (int i = 0; i < self.sectionArray.count; i++) {
        
        int col = i / 3;//列
        int row = i % 3;//行
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(row*(sectionWidth + marge) + marge,col*(sectionHeight + marge)+ y , sectionWidth, sectionHeight);
        NSDictionary *dic = self.sectionArray[i];
        NSString *money = dic[@"value"];
        btn.layer.cornerRadius = 10;
        btn.layer.borderWidth = 2;
        btn.layer.borderColor = Color(252, 186, 0, 1.0).CGColor;
        [btn setTitle:[NSString stringWithFormat:@"%@元",money] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickToRecharge:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [_rechargeContentView addSubview:btn];
        [_sectionButtons addObject:btn];
    }
    
    
}

#pragma mark -- 选择的充值金额
- (void)didClickToRecharge:(UIButton *)sender {
    
    if (self.userSelectedBtn == sender) {
        
        self.userSelectedBtn.backgroundColor = Color(252, 186, 0, 1);
    } else {
        self.userSelectedBtn.backgroundColor = [UIColor whiteColor];
        sender.backgroundColor = Color(252, 186, 0, 1);
    }
    
    self.userSelectedBtn = sender;
    
    NSLog(@"%@",[self selectedSectionWithButton:self.userSelectedBtn]);

    
}

- (NSString *)selectedSectionWithButton:(UIButton *)selectedBtn {
    
    NSDictionary *dic = self.sectionArray[selectedBtn.tag];
    
    return dic[@"value"];
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

- (void)loadRechargeRange {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonRechargeSection];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getCommonRechargeSection >>>>>>>> %@",dataBack);
        NSDictionary *content = dataBack[@"content"];
        if ([dataBack[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in content[@"section"]) {
                [self.sectionArray addObject:dic];
            }
            [self setupUI];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败！"];
    }];
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
        [_HUD hideAnimated:YES];
        NSDictionary *content = dataBack[@"content"];
        if ([dataBack[@"code"] integerValue] == 0) {
            [_protocolWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,content[@"url"]]]]];
        }else{
            //[self showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败！"];
        [_HUD hideAnimated:YES];
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_HUD hideAnimated:YES];
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] integerValue];
    _protocolWV.frame=CGRectMake(0, CGRectGetMaxY(_rechargeChooseView.frame), ScreenWidth, height);
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
    parameters[@"money"] = @([[self selectedSectionWithButton:self.userSelectedBtn] floatValue]);
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
        [_rechargeHUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_rechargeHUD hideAnimated:YES];
    }];
}

- (void)gotoRechargeEvent:(UIButton *)btn{
    if (btn.tag == 10000) {
        if (self.userSelectedBtn == nil) {
            [self showHudMessage:@"请选择充值金额!"];
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
