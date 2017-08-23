//
//  LoginViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewCtl.h"
#import "ForgetViewController.h"
#import "InformationViewController.h"
#import "JPUSHService.h"
#import "MainCimemaViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIImageView *_loginHeadImg;
    UIScrollView *_scrollView;
    UITextField *_phoneTextField;
    UITextField *_passwordTextField;
    MBProgressHUD *_HUD;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
    [self registerLJWKeyboardHandler];
    
    _scrollView = [UIViewController createScrollView];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [self initLoginUI];
}

- (void)initLoginUI{
    _loginHeadImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 100, 100) image:[UIImage imageNamed:@"Login_head"] tag:1000];
    _loginHeadImg.center = CGPointMake(ScreenWidth/2, 130);
    [_scrollView addSubview:_loginHeadImg];
    
    NSArray *leftArr = @[@"手机号",@"密   码"];
    NSArray *placeholderArr = @[@"请输入手机号",@"请输入密码"];
    NSArray *imgArr = @[@"Login_phone",@"Login_password"];
    for (int i=0; i<leftArr.count; i++) {
        CGSize leftSize = [FanShuToolClass createString:leftArr[0] font:[UIFont systemFontOfSize:17] lineSpacing:0  maxSize:CGSizeMake(150, 30)];
        // textField左边视图
        UIView *leftView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, 40+leftSize.width, 50) backgroundColor:[UIColor clearColor]];
        // 视图图标
        UIImageView *leftImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(8, 13, 16, 24) image:[UIImage imageNamed:imgArr[i]] tag:1001+i];
        leftImg.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:leftImg];
        // 视图文字
        UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(35, 0, leftSize.width, 50) text:leftArr[i] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [leftView addSubview:leftLb];
        
        UITextField *textField = [FanShuToolClass createTextFieldWithFrame:CGRectMake(0, 220+50*i, ScreenWidth, 50) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17] target:self];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = placeholderArr[i];
        textField.leftView = leftView;
        [_scrollView addSubview:textField];
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            _phoneTextField = textField;
            _phoneTextField.delegate = self;
        }else{
            // 每输入一个字符就变成点用语密码输入
            textField.secureTextEntry = YES;
            // 键盘风格为数字
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _passwordTextField = textField;
        }
    }
    
    // 登录
    UIButton *loginBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, 340, ScreenWidth-30, 50) title:@"登录" titleColor:[UIColor whiteColor] target:self action:@selector(loginClick:) tag:100];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    loginBtn.backgroundColor = COLOR_NAVAAR;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4.0f;
    [_scrollView addSubview:loginBtn];
    
    // 忘记密码、快速注册
    NSArray *buttonArr = @[@"忘记密码？",@"快速注册"];
    for (int i=0; i<buttonArr.count; i++) {
        CGSize buttonSize = [FanShuToolClass createString:buttonArr[i] font:[UIFont systemFontOfSize:15] lineSpacing:0 maxSize:CGSizeMake((ScreenWidth-30)/2, 24)];
        UIButton *button = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, buttonSize.width, 24) title:buttonArr[i] titleColor:[UIColor grayColor] target:self action:@selector(loginClick:) tag:101+i];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_scrollView addSubview:button];
        
        UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, buttonSize.width, 1) backgroundColor:[UIColor lightGrayColor]];
        [_scrollView addSubview:lineView];
        
        if (i == 0) {
            button.frame = CGRectMake(15, 410, buttonSize.width, 24);
            lineView.frame = CGRectMake(15, 435, buttonSize.width, 1);
        }else{
            button.frame = CGRectMake(ScreenWidth-15-buttonSize.width, 410, buttonSize.width, 24);
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            lineView.frame = CGRectMake(ScreenWidth-15-buttonSize.width, 435, buttonSize.width, 1);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 直接出来登录的手机号码
    _phoneTextField.text = ApimobileStr;
}

// 键盘掉下
- (void)keyBoardDown{
    [_phoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)loginClick:(UIButton *)btn{
    [self keyBoardDown];
    if (btn.tag == 100) {
        if ([self checkLoginInfo]) {
#pragma mark - 用户登录
            _HUD = [FanShuToolClass createMBProgressHUDWithText:@"登录中..." target:self];
            [self.view addSubview:_HUD];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiLoginURL];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = _phoneTextField.text;// 必须, 手机号
            parameters[@"password"] = _passwordTextField.text;// 必须, 密码
            parameters[@"group_id"] = ApiGroup_ID;// 必须, 影院组ID，每个APP有固定的影院组ID
            parameters[@"lng"] = ApiLngStr;// 可选, 手机当前经度，百度坐标
            parameters[@"lat"] = ApiLatStr;// 可选, 手机当前纬度，百度坐标
            ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
            [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
                if (dataBack) {
                    NSString *codeStr = [NSString stringWithFormat:@"%@",dataBack[@"code"]];
                    if ([codeStr isEqualToString:@"0"]) {
                        [self showHudMessage:@"登录成功!"];
                        // umeng账号统计
                        [MobClick profileSignInWithPUID:_phoneTextField.text];
                        
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
                        
                        // 上极光推送registrationID
                        [self uploadRegistrationID];
                        
                        //登录后刷新影院模块
//                        UINavigationController *nav = self.tabBarController.viewControllers[0];
//                        CinemaViewController *cinema = [nav.viewControllers objectAtIndex:0];
//                        cinema.currentPage = 0;
//                        [cinema.cinemaTableView removeFromSuperview];
//                        cinema.cinemaTableView = nil;
//                        cinema.HUD = nil;
//                        [cinema.slidersArr removeAllObjects];
//                        [cinema.filmsArr removeAllObjects];
//                        cinema.cinemaMsg = nil;
                        
                        UINavigationController *newNavigationController1 = self.tabBarController.viewControllers[1];
                        InformationViewController *informationCtl = [newNavigationController1.viewControllers objectAtIndex:0];
                        if (informationCtl.informationArr.count != 0) {
                            informationCtl.currentPage = 0;
                            [informationCtl.informationTableView removeFromSuperview];
                            informationCtl.informationTableView = nil;
                            [informationCtl.informationArr removeAllObjects];
                            [informationCtl.slidersArr removeAllObjects];
                        }
                        
                        double delayInSeconds = 0.5f;
                        __block LoginViewController *loginCtl = self;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^{
                            [loginCtl.navigationController popViewControllerAnimated:YES];
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
                         40002
                         46005
                         */
                        [self showHudMessage:dataBack[@"message"]];
                    }
                }
                [_HUD hide:YES];
            } failure:^(NSError *error) {
                [self showHudMessage:@"连接服务器失败!"];
                [_HUD hide:YES];
            }];
        }
    }else if (btn.tag == 101) {
        ForgetViewController *forget = [[ForgetViewController alloc] init];
        [self.navigationController pushViewController:forget animated:YES];
    }else if (btn.tag == 102) {
        RegisterViewCtl *regi = [[RegisterViewCtl alloc] init];
        [self.navigationController pushViewController:regi animated:YES];
    }
}

// 上传JPush的RegistrationID
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

- (BOOL)checkLoginInfo{
    if (![_phoneTextField.text isMobile]) {
        [self showHudMessage:@"请输入手机号"];
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
}

@end
