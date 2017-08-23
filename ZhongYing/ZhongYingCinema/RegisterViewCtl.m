//
//  RegisterViewCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "RegisterViewCtl.h"
#import "LFSPopupView.h"
#import "ProcotolViewController.h"

@interface RegisterViewCtl ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIView *_whiteView;
    UIScrollView *_scrollView;
    UITextField *_phoneTextField;
    UITextField *_codeTextField;
    UITextField *_passwordTextField;
    UITextField *_nameTextField;
    UIButton *_codeBtn;
    // 年龄、性别
    UILabel *_yearLb;
    UILabel *_sexLb;
    UIImageView *_sexImg;
    // 短信验证码
    NSString *_verifyCodeStr;
    MBProgressHUD *_HUD;
    UIButton *_protocolBtn;
}
@end

@implementation RegisterViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册";
    
    _scrollView = [UIViewController createScrollView];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _whiteView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 300) backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_whiteView];
    
    [self initRegisterUI];
    // 键盘
    [self registerLJWKeyboardHandler];
}

- (void)initRegisterUI{
    NSArray *placeholderArr = @[@"手机号",@"验证码",@"密码"/*,@"姓名"*/];
    for (int i=0; i<placeholderArr.count; i++) {
        UIView *leftView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, 15, 50) backgroundColor:[UIColor whiteColor]];
        CGSize btnSize = [placeholderArr[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, 0, btnSize.width, 50) title:placeholderArr[i] titleColor:Color(40, 40, 40, 1.0) target:nil action:nil tag:888 +i];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, 80, 50) backgroundColor:[UIColor whiteColor]];
        [view addSubview:leftView];
        [view addSubview:btn];
        
        UITextField *textField = [FanShuToolClass createTextFieldWithFrame:CGRectMake(0, 50*i, ScreenWidth, 50) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17] target:self];
        textField.backgroundColor = [UIColor whiteColor];
        if (i == 2) {
            textField.placeholder = @"6-20位字母、数字";
        }
        
        textField.leftView = view;
        [_whiteView addSubview:textField];
        
        UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(15, 49.5+50*i, ScreenWidth-15, 0.5f) backgroundColor:[UIColor lightGrayColor]];
        [_whiteView addSubview:lineView];
        
        if (i==0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            _phoneTextField = textField;
            _phoneTextField.delegate = self;
        }else if (i == 1) {
            // 键盘风格为数字
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.frame = CGRectMake(0, 50*i, ScreenWidth-110, 50);
            _codeTextField = textField;
            
            _codeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth-110, 50*i+3, 100, 44) title:@"获取验证码" titleColor:[UIColor whiteColor] target:self action:@selector(gotoRegisterEvent:) tag:100];
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.layer.cornerRadius = 4.0f;
            [_codeBtn setBackgroundColor:COLOR_NAVAAR];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [_whiteView addSubview:_codeBtn];
        }else if (i == 2) {
            // 每输入一个字符就变成点用语密码输入
            textField.secureTextEntry = YES;
            // 键盘风格为数字
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            textField.frame = CGRectMake(0, 50*i, ScreenWidth-50, 50);
            _passwordTextField = textField;
            
            // 密码明文按钮
            UIButton *passwordBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth-50, 50*i+5, 50, 40) image:[UIImage imageNamed:@"Login_no_see"] target:self action:@selector(gotoRegisterEvent:) tag:102];
            [_whiteView addSubview:passwordBtn];
        }else {
            _nameTextField = textField;
        }
    }
    
    // 年龄段、性别
    NSArray *yearArr = @[@"年龄段",/*@"性别"*/];
    for (int i=0; i<yearArr.count; i++) {
        UIView *yearView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 150+50*i, ScreenWidth, 50) backgroundColor:[UIColor clearColor]];
        yearView.tag = 10000+i;
        [_whiteView addSubview:yearView];
        
        UILabel *yearLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15, 0, ScreenWidth/2-20, 50) text:yearArr[i] font:[UIFont systemFontOfSize:17] textColor:Color(40, 40, 40, 1.0) alignment:NSTextAlignmentLeft];
        [yearView addSubview:yearLb];
        
        UIImageView *rightImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-30, 16, 10, 18) image:[UIImage imageNamed:@"Login_arrow"] tag:1000];
        [yearView addSubview:rightImg];
        
        UITapGestureRecognizer *yearTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yearTapClick:)];
        [yearView addGestureRecognizer:yearTap];
        
        if (i == 0) {
            UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(15, 49.5, ScreenWidth-15, 0.5f) backgroundColor:[UIColor lightGrayColor]];
            [yearView addSubview:lineView];
            
            _yearLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-40, 50) text:@"20岁以下" font:[UIFont systemFontOfSize:17] textColor:[UIColor grayColor] alignment:NSTextAlignmentRight];
            [yearView addSubview:_yearLb];
        }else {
            _sexLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth-70, 0, 30, 50) text:@"男" font:[UIFont systemFontOfSize:17] textColor:[UIColor grayColor] alignment:NSTextAlignmentRight];
            [yearView addSubview:_sexLb];
            
            _sexImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-80, 14, 14, 22) image:[UIImage imageNamed:@"Login_sex_man"] tag:1001];
            [yearView addSubview:_sexImg];
        }
    }
    
    // 注册、注册协议
    UIButton *registerBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, 340, ScreenWidth-30, 50) title:@"注册" titleColor:[UIColor whiteColor] target:self action:@selector(gotoRegisterEvent:) tag:101];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    registerBtn.backgroundColor = COLOR_NAVAAR;
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 4.0f;
    [_scrollView addSubview:registerBtn];
    
    UIButton *protocolBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, 400, 40, 40) image:[UIImage imageNamed:@"Login_protocol"] target:self action:@selector(gotoRegisterEvent:) tag:103];
    [_scrollView addSubview:protocolBtn];
    _protocolBtn = protocolBtn;
    _protocolBtn.selected = YES;
    
    CGSize protocol = [FanShuToolClass createString:@"注册协议" font:[UIFont systemFontOfSize:16]  lineSpacing:0 maxSize:CGSizeMake(150, 40)];
    UIButton *protocolTextBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(55, 405, protocol.width, 30) title:@"注册协议" titleColor:Color(82, 166, 249, 1.0) target:self action:@selector(gotoRegisterEvent:) tag:104];
    protocolTextBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    protocolTextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:protocolTextBtn];
    
    CGSize tips = [FanShuToolClass createString:@"注：为了您的账号安全请填写正确信息。" font:[UIFont systemFontOfSize:12] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth -55, 15)];
    UILabel *tipsLb = [FanShuToolClass createLabelWithFrame:CGRectMake(55, 435, tips.width, 15) text:@"注：为了您的账号安全请填写正确信息。" font:[UIFont systemFontOfSize:12] textColor:Color(90, 90, 90, 1.0) alignment:NSTextAlignmentLeft];
    [_scrollView addSubview:tipsLb];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tipsLb.text];
    NSRange range = [tipsLb.text rangeOfString:@"注："];
    [str addAttributes:@{NSForegroundColorAttributeName : Color(246, 96, 116, 1.0)} range:range];
    tipsLb.attributedText = str;
}

// 键盘掉下
- (void)keyBoardDown{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
}

- (void)yearTapClick:(UITapGestureRecognizer *)tap{
    [self keyBoardDown];
    if (tap.view.tag == 10000) {
        // 展示年龄段
        NSArray *yearArr = @[@"20岁以下",@"20-30岁",@"31-40岁",@"40岁以上"];
        LFSPopupView *popupView = [[LFSPopupView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:popupView];
        
        [popupView createTableViewWithArr:yearArr withTitle:@"修改年龄段" withBackColor:Color(98, 98, 98, 0.6) withType:LFSPopup_year withLFSBlock:^(int tag) {
            _yearLb.text = yearArr[tag];
        }];
    }else {
        // 展示性别
        NSArray *sexArr = @[@"男",@"女"];
        LFSPopupView *popupView = [[LFSPopupView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:popupView];
        
        [popupView createTableViewWithArr:sexArr withTitle:@"修改性别" withBackColor:Color(98, 98, 98, 0.6) withType:LFSPopup_sex withLFSBlock:^(int tag) {
            _sexLb.text = sexArr[tag];
            NSArray *sexImgArr = @[@"Login_sex_man",@"Login_sex_woman"];
            _sexImg.image = [UIImage imageNamed:sexImgArr[tag]];
        }];
    }
}

- (void)gotoRegisterEvent:(UIButton *)btn{
    [self keyBoardDown];
    if (btn.tag == 100) {
        if (![_phoneTextField.text isMobile]) {
            [self showHudMessage:@"请输入有效的手机号"];
        }else {
#pragma mark - 多线程做时间倒计时
            __block int timeout = 59; // 倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); // 每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ // 倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 设置界面的按钮显示 根据自己需求设置
                        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        _codeBtn.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 设置界面的按钮显示 根据自己需求设置
                        [_codeBtn setTitle:[NSString stringWithFormat:@"还剩%@秒",strTime] forState:UIControlStateNormal];
                        _codeBtn.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
#pragma mark - 获取验证码
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiVerifyURL];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = _phoneTextField.text;
            ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
            [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
                if (dataBack) {
                    NSString *codeStr = [NSString stringWithFormat:@"%@",dataBack[@"code"]];
                    if ([codeStr isEqualToString:@"0"]) {
                        //_codeTextField.text = [NSString stringWithFormat:@"%@",dataBack[@"content"][@"verifyCode"]];
                        _verifyCodeStr = [NSString stringWithFormat:@"%@",dataBack[@"content"][@"verifyCode"]];
                    }else {
                        // 其他可能产生的错误
                        /*
                         43001
                         60000
                         41006
                         41001
                         60001
                         */
                        [self showHudMessage:dataBack[@"message"]];
                    }
                }
            } failure:^(NSError *error) {
                [self showHudMessage:@"连接服务器失败!"];
            }];
        }
    }else if (btn.tag == 101) {
        if ([self checkRegisterInfo]) {
#pragma mark - 用户注册
            _HUD = [FanShuToolClass createMBProgressHUDWithText:@"注册中..." target:self];
            [self.view addSubview:_HUD];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiRegisterURL];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = _phoneTextField.text;// 必须, 手机号
            parameters[@"password"] = _passwordTextField.text;// 必须, 密码
            parameters[@"code"] = _codeTextField.text;// 必须, 短信验证码
            parameters[@"group_id"] = ApiGroup_ID;// 必须, 影院组ID，每个APP有固定的影院组ID
            parameters[@"lng"] = ApiLngStr;// 可选, 手机当前经度，百度坐标
            parameters[@"lat"] = ApiLatStr;// 可选, 手机当前纬度，百度坐标
            if (![_nameTextField.text isEqualToString:@""]) {
                parameters[@"name"] = _nameTextField.text;
            }
            if ([_yearLb.text isEqualToString:@""]){
                parameters[@"age"] = @(0);
            }else {
                NSArray *yearArr = @[@"20岁以下",@"20-30岁",@"31-40岁",@"40岁以上"];
                for (NSInteger i = 0; i < yearArr.count; i ++) {
                    if ([_yearLb.text isEqualToString:yearArr[i]]) {
                        parameters[@"age"] = @(i +1);
                        break;
                    }
                }
            }
            
            if ([_sexLb.text isEqualToString:@""]){
                parameters[@"gender"] = @(0);
            }else {
                NSArray *sexArr = @[@"男",@"女"];
                for (NSInteger i = 0; i < sexArr.count; i ++) {
                    if ([_sexLb.text isEqualToString:sexArr[i]]) {
                        parameters[@"gender"] = @(i +1);
                        break;
                    }
                }
            }
            ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
            [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
                if (dataBack) {
                    NSString *codeStr = [NSString stringWithFormat:@"%@",dataBack[@"code"]];
                    if ([codeStr isEqualToString:@"0"]) {
                        [self showHudMessage:@"注册成功!"];
                        // 存储返回数据，返回主界面
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"id"] forKey:@"Apiid"];// 用户ID
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"group_id"] forKey:@"Apigroup_id"];// 影院组ID
                        [[NSUserDefaults standardUserDefaults] setObject:_phoneTextField.text forKey:@"Apimobile"];// 手机号码
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"name"] forKey:@"Apiname"];// 用户姓名
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"nickname"] forKey:@"Apinickname"];// 用户昵称
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"avatar"] forKey:@"Apiavatar"];// 头像
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"gender"] forKey:@"Apigender"];// 性别，枚举值，0-未设置|1-男|2-女
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"age"] forKey:@"Apiage"];// 年龄，枚举值，0-未设置|1-20岁以下|2-20-30岁|3-31-40岁|4-40岁以上
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"login_ip"] forKey:@"Apilogin_ip"];// 登录IP
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"login_time"] forKey:@"Apilogin_time"];// 时间戳，上次登录时间
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"login_times"] forKey:@"Apilogin_times"];// 登录次数
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"created_time"] forKey:@"Apicreated_time"];// 时间戳，用户创建时间
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"status"] forKey:@"Apistatus"];// 用户状态，枚举值，0-禁用|1-正常，这里只会是1，为0时接口会产生50001错误
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"token"] forKey:@"Apitoken"];// 令牌，请求其它接口时需要
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"cinema_id"] forKey:@"Apicinema_id"];// 影院ID
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UserLogin"];// 设置登录状态为YES
                        
                        // 存储手机号码，返回登录界面
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"mobile"] forKey:@"Apimobile"];
                        
                        // 上极光推送registrationID
                        [self uploadRegistrationID];
                        
                        double delayInSeconds = 0.5f;
                        __block RegisterViewCtl *registerCtl = self;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^{
                            //[registerCtl.navigationController popToRootViewControllerAnimated:YES];
                            UIViewController *controller;
                            if (self.navigationController.viewControllers.count > 2) {
                                controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count -3];
                            }else{
                                controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count -2];
                            }
                            
                            [registerCtl.navigationController popToViewController:controller animated:YES];
                        });
                    }else {
                        // 其他可能产生的错误
                        /*
                         43001
                         60000
                         41006
                         41001
                         41002
                         41009
                         43002
                         40003
                         50002
                         46005
                         */[self showHudMessage:dataBack[@"message"]];
                    }
                }
                [_HUD hide:YES];
            } failure:^(NSError *error) {
                [self showHudMessage:@"连接服务器失败!"];
                [_HUD hide:YES];
            }];
        }
    }else if (btn.tag == 102) {
        static BOOL flag;
        if (flag) {
            [btn setImage:[UIImage imageNamed:@"Login_no_see"] forState:UIControlStateNormal];
            _passwordTextField.secureTextEntry = YES;
        }else {
            [btn setImage:[UIImage imageNamed:@"Login_see"] forState:UIControlStateNormal];
            _passwordTextField.secureTextEntry = NO;
        }
        flag = !flag;
    }else if (btn.tag == 103) {
        btn.selected = !btn.selected;
        static BOOL flag;
        if (flag) {
            [btn setImage:[UIImage imageNamed:@"Login_protocol"] forState:UIControlStateNormal];
        }else {
            [btn setImage:[UIImage imageNamed:@"Login_no_protocol"] forState:UIControlStateNormal];
        }
        flag = !flag;
    }else{
        ProcotolViewController *procotol = [[ProcotolViewController alloc] init];
        [self.navigationController pushViewController:procotol animated:YES];
    }
}

- (BOOL)checkRegisterInfo{
    if (![_phoneTextField.text isMobile]) {
        [self showHudMessage:@"请输入手机号"];
        return NO;
    }else if (_codeTextField.text.length == 0) {
        [self showHudMessage:@"请输入验证码"];
        return NO;
    }else if (![_verifyCodeStr isEqualToString:_codeTextField.text]) {
        [self showHudMessage:@"验证码错误"];
        return NO;
    }else if (![_passwordTextField.text createPasswordByLimit]) {
        [self showHudMessage:@"请输入6-20位数密码"];
        return NO;
    }else if (!_protocolBtn.selected){
        [self showHudMessage:@"请同意并勾选注册协议"];
        return NO;
    }
    return YES;
}

- (void)uploadRegistrationID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserParametersURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"registration_id"] = JPushRegistrationID;
    parameters[@"app_type"] = @(2);
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getUploadRegistrationIDResult>>>>>>>>>>>>>>>>>>>%@",dataBack);
    } failure:^(NSError *error) {
        NSLog(@"连接服务器失败!");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 20) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_phoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
}

@end
