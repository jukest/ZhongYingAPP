//
//  ForgetViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIView *_whiteView;
    UIScrollView *_scrollView;
    UITextField *_phoneTextField;
    UITextField *_codeTextField;
    UITextField *_passwordTextField;
    UIButton *_codeBtn;
    // 短信验证码
    NSString *_verifyCodeStr;
    MBProgressHUD *_HUD;
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"重置密码";
    
    _scrollView = [UIViewController createScrollView];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _whiteView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 150) backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_whiteView];
    
    [self initForgetUI];
}

- (void)initForgetUI{
    NSArray *placeholderArr = @[@"手机号",@"验证码",@"密码"];
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
            
            _codeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth-110, 50*i+3, 100, 44) title:@"获取验证码" titleColor:[UIColor whiteColor] target:self action:@selector(gotoForgetEvent:) tag:100];
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.layer.cornerRadius = 4.0f;
            [_codeBtn setBackgroundColor:COLOR_NAVAAR];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [_whiteView addSubview:_codeBtn];
        }else {
            lineView.hidden = YES;
            // 每输入一个字符就变成点用语密码输入
            textField.secureTextEntry = YES;
            // 键盘风格为数字
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            textField.frame = CGRectMake(0, 50*i, ScreenWidth-50, 50);
            _passwordTextField = textField;
            
            // 密码明文按钮
            UIButton *passwordBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth-50, 50*i+5, 50, 40) image:[UIImage imageNamed:@"Login_no_see"] target:self action:@selector(gotoForgetEvent:) tag:102];
            [_whiteView addSubview:passwordBtn];
        }
    }
    
    // 提交
    UIButton *commitBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, 180, ScreenWidth-30, 50) title:@"提交" titleColor:[UIColor whiteColor] target:self action:@selector(gotoForgetEvent:) tag:101];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    commitBtn.backgroundColor = COLOR_NAVAAR;
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4.0f;
    [_scrollView addSubview:commitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 键盘掉下
- (void)keyBoardDown{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)gotoForgetEvent:(UIButton *)btn{
    [self keyBoardDown];
    if (btn.tag == 100) {
        if (![_phoneTextField.text isMobile]) {
            [self showHudMessage:@"请输入手机号"];
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
                        _codeTextField.text = [NSString stringWithFormat:@"%@",dataBack[@"content"][@"verifyCode"]];
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
                    }
                }
            } failure:^(NSError *error) {
                [self showHudMessage:@"连接服务器失败!"];
            }];
        }
    }else if (btn.tag == 101) {
        if ([self checkForgetInfo]) {
#pragma mark - 找回密码
            _HUD = [FanShuToolClass createMBProgressHUDWithText:@"找回密码中..." target:self];
            [self.view addSubview:_HUD];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiFindPasswordURL];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = _phoneTextField.text;// 必须, 手机号
            parameters[@"password"] = _passwordTextField.text;// 必须, 密码
            parameters[@"code"] = _codeTextField.text;// 必须, 短信验证码
            parameters[@"group_id"] = ApiGroup_ID;// 必须, 影院组ID，每个APP有固定的影院组ID
            parameters[@"lng"] = ApiLngStr;// 可选, 手机当前经度，百度坐标
            parameters[@"lat"] = ApiLatStr;// 可选, 手机当前纬度，百度坐标
            ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
            [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
                if (dataBack) {
                    NSString *codeStr = [NSString stringWithFormat:@"%@",dataBack[@"code"]];
                    if ([codeStr isEqualToString:@"0"]) {
                        [self showHudMessage:@"找回密码成功!"];
                        // 存储手机号码，返回登录界面
                        [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"mobile"] forKey:@"Apimobile"];
                        double delayInSeconds = 0.5f;
                        __block ForgetViewController *forgetCtl = self;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^{
                            [forgetCtl.navigationController popViewControllerAnimated:YES];
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
                         46001
                         50001
                         46005
                         */
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
    }
}

- (BOOL)checkForgetInfo{
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
    }
    return YES;
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
}

@end
