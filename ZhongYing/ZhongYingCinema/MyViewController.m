//
//  MyViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyViewController.h"
#import "MyLoginView.h"
#import "MyView.h"
#import "MyTableViewCell.h"
#import "LoginViewController.h"
#import "RegisterViewCtl.h"
#import "MyInformationViewCtl.h"
#import "RechargeViewController.h"
#import "MyOrderViewCtl.h"
#import "EvaluateViewCtl.h"
#import "MyBillViewController.h"
#import "AboutUsViewCtl.h"
#import "MyCouponViewCtl.h"
#import "MoreCinemaViewCtl.h"
#import "MyReviewViewCtl.h"
#import "MyMessageViewCtl.h"
#import "MyCollectionViewCtl.h"
#import "MyCommentViewCtl.h"
#import "ComplaintViewCtl.h"
#import "IntegralMallViewCtl.h"
#import "RefundView.h"

// 最上面视图高度
#define HEIGHT_MyView 280
// 最上面没有登录视图高度
#define HEIGHT_MyLoginView 120

@interface MyViewController ()<MyViewDelegate,MyLoginViewDelegate,RefundViewDelegate>
{
    NSArray *_cellLeftArr;
    MBProgressHUD *_HUD;
}
@property (nonatomic,strong) MyView *myView;
@property (nonatomic,strong) MyLoginView *myLoginView;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMyViewCtlUI];
    [self addRefreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 隐藏导航栏[解决导航栏问题两个方法中实现1、viewWillAppear；2、viewWillDisappear]
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 每次刚开始的时候刷新tableHeaderView
    _myTableView.tableHeaderView = [self getTableHeaderView];
    _myTableView.tableFooterView = [self getTableFooterView];
    
    if ([LoginYesOrNoStr isEqualToString:@"YES"]) {
        [self loadMyself];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFromApn"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 0;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFromApn"];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initMyViewCtlUI{
    // 初始化cell左边文字
    _cellLeftArr = @[@[@"我的账单",@"我的影评",@"我的消息",@"我的收藏",@"我的评论",@"我的优惠券"],@[@"关注影院",@"积分商城",@"投诉统计",@"关于我们"]];
    // 设置状态栏的背景色
    UIView *topStatusView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 20) backgroundColor:Color(252, 186, 0, 1.0)];
    [self.view addSubview:topStatusView];
    
}

- (void)loadMyself
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMyselfURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if (_myTableView.mj_header.isRefreshing) {
            [_myTableView.mj_header endRefreshing];
        }
        NSLog(@"getMyself>>>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            [self.myView configMyViewWithContent:content];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",[content[@"balance"][@"remain"] floatValue]] forKey:@"myremain"];// 余额
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",[content[@"balance"][@"score"] integerValue]] forKey:@"myscore"];// 积分
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",[content[@"comment"] integerValue]] forKey:@"mycomment"];// 评论
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        if (_myTableView.mj_header.isRefreshing) {
            [_myTableView.mj_header endRefreshing];
        }
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

#pragma mark - 懒加载
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, HEIGHT_STATUSBAR, ScreenWidth, ScreenHeight-HEIGHT_STATUSBAR-HEIGHT_TABBAR) style:UITableViewStyleGrouped target:self];
        _myTableView.tableHeaderView = [self getTableHeaderView];
        //_myTableView.backgroundColor = Color(252, 186, 0, 1.0);
        [_myTableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"MyTableViewCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

// tableHeaderView
- (UIView *)getTableHeaderView{
    
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {// 如果在没有登入的情况
        _myLoginView = [[MyLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT_MyLoginView)];
        _myLoginView.delegate = self;
        return _myLoginView;
    }else {
        _myView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT_MyView)];
        _myView.delegate = self;
        return _myView;
    }
}

- (UIView *)getTableFooterView
{
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {// 如果在没有登入的情况
        return nil;
    }else {
        UIView *footerView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 100) backgroundColor:[UIColor clearColor]];
        UIButton *loginOutBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12, 30, ScreenWidth -24, 50) title:@"退出登录" titleColor:[UIColor whiteColor] cornerRadius:3.0 font:[UIFont systemFontOfSize:18] backgroundColor:Color(252, 186, 0, 1.0) target:self action:@selector(loginOut:) tag:66];
        [footerView addSubview:loginOutBtn];
        return footerView;
    }
}

// 刷新实现
- (void)addRefreshView{
    __weak MyViewController *my = self;
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([LoginYesOrNoStr isEqualToString:@"YES"]) {
            [my loadMyself];
        }else{
            [my.myTableView.mj_header endRefreshing];
        }
    }];
    MJRefreshNormalHeader *h = (MJRefreshNormalHeader *)self.myTableView.mj_header;
    h.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    h.stateLabel.textColor = [UIColor whiteColor];
}

//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color withImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)loginOut:(UIButton *)btn
{
 
    NSString *content = @"确定要退出吗？";
    CGSize contentSize = [FanShuToolClass createString:content font:[UIFont systemFontOfSize:16] lineSpacing:7 maxSize:CGSizeMake(ScreenWidth -60 -80, ScreenHeight)];
    RefundView *refund = [[RefundView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth -60, 95 +contentSize.height) WithContent:content];
    refund.headerView.hidden = YES;
    refund.contentView.frame = CGRectMake(23, 20 +17 +5, ScreenWidth -60 -80, contentSize.height);
    refund.contentView.center = CGPointMake(refund.frame.size.width / 2, (95 +contentSize.height -47) / 2);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.firstLineHeadIndent = 0;
    [paraStyle setLineSpacing:7];
    [str addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
    refund.contentView.attributedText = str;
    
    refund.delegate = self;
    [refund show];
}

#pragma mark - RefundViewDelegate
- (void)gotoRefundViewEvents:(NSInteger)tag
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiid"];// 用户ID
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apimobile"];// 手机号码
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiname"];// 用户姓名
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apinickname"];// 用户昵称
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiavatar"];// 头像
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apigender"];// 性别，枚举值，0-未设置|1-男|2-女
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apiage"];// 年龄，枚举值，0-未设置|1-20岁以下|2-20-30岁|3-31-40岁|4-40岁以上
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apitoken"];// 令牌，请求其它接口时需要
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Apicinema_id"];// 影院ID
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"UserLogin"];// 设置登录状态为NO
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"myremain"];// 余额
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"myscore"];// 积分
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"mycomment"];// 评论
    
    //umeng统计账号登出需调用此接口，调用之后不再发送账号相关内容。
    [MobClick profileSignOff];
    [self showHudMessage:@"退出成功"];
    _myTableView.tableHeaderView = [self getTableHeaderView];
    _myTableView.tableFooterView = [self getTableFooterView];
    [_myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cellLeftArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_cellLeftArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 10) backgroundColor:Color(239, 239, 239, 1.0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    cell.leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"my_%zd_%zd",indexPath.section,indexPath.row]];
    cell.leftLb.text = _cellLeftArr[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!(indexPath.section ==1 && indexPath.row == 3) && ![LoginYesOrNoStr isEqualToString:@"YES"]) {
            [(ZYNavigationController *)self.navigationController showLoginViewController];
    }else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            // 前往账单
            MyBillViewController *myBill = [[MyBillViewController alloc] init];
            [myBill setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myBill animated:YES];
        }else if (indexPath.section == 1 && indexPath.row == 3) {
            // 前往关于我们
            AboutUsViewCtl *aboutUs = [[AboutUsViewCtl alloc] init];
            [aboutUs setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }else if (indexPath.section == 0 && indexPath.row == 5) {
            // 前往优惠券
            MyCouponViewCtl *coupon = [[MyCouponViewCtl alloc] init];
            [coupon setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:coupon animated:YES];
        }else if (indexPath.section == 1 && indexPath.row == 0){
            // 前往关注影院
            MoreCinemaViewCtl *concernCinema = [[MoreCinemaViewCtl alloc] init];
            concernCinema.cinemaType = @"关注影院";
            [concernCinema setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:concernCinema animated:YES];
        }else if (indexPath.section == 0 && indexPath.row == 1){
            // 我的影评
            MyReviewViewCtl *myReview = [[MyReviewViewCtl alloc] init];
            [myReview setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myReview animated:YES];
        }else if (indexPath.section == 0 && indexPath.row == 2){
            // 我的消息
            MyMessageViewCtl *myMessage = [[MyMessageViewCtl alloc] init];
            [myMessage setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myMessage animated:YES];
        }else if (indexPath.section == 0 && indexPath.row == 3){
            // 我的收藏
            MyCollectionViewCtl *myCollection = [[MyCollectionViewCtl alloc] init];
            [myCollection setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myCollection animated:YES];
        }else if (indexPath.section == 0 && indexPath.row == 4){
            // 我的评论
            MyCommentViewCtl *myComment = [[MyCommentViewCtl alloc] init];
            [myComment setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myComment animated:YES];
        }else if (indexPath.section == 1 && indexPath.row == 2){
            // 投诉统计
            ComplaintViewCtl *complaint = [[ComplaintViewCtl alloc] init];
            [complaint setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:complaint animated:YES];
        }else if (indexPath.section == 1 && indexPath.row == 1){
            IntegralMallViewCtl *integralMall = [[IntegralMallViewCtl alloc] init];
            [integralMall setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:integralMall animated:YES];
        }
    }
}

#pragma mark - MyViewDelegate
- (void)MyViewDelegateWithTag:(NSInteger)tag{
    if (tag == 100) {
        // 前往充值
        RechargeViewController *rechargeCtl = [[RechargeViewController alloc] init];
        [rechargeCtl setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:rechargeCtl animated:YES];
    }else if (tag == 101) {
        // 前往我的账单
        MyOrderViewCtl *myOrder = [[MyOrderViewCtl alloc] init];
        myOrder.isFromPayMent = NO;
        [myOrder setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:myOrder animated:YES];
    }else if (tag == 102) {
        // 前往待评价
        EvaluateViewCtl *evaluate = [[EvaluateViewCtl alloc] init];
        [evaluate setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:evaluate animated:YES];
    }
}

- (void)MyViewDelegateClickHead{
    // 前往我的资料
    MyInformationViewCtl *myInformation = [[MyInformationViewCtl alloc] init];
    [myInformation setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:myInformation animated:YES];
}

#pragma mark - MyLoginViewDelegate
- (void)MyLoginViewClickWithTag:(NSInteger)tag{
    if (tag == 100) {
        // 前往登录界面
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
    }else {
        // 前往注册界面
        RegisterViewCtl *registerCtl = [[RegisterViewCtl alloc] init];
        [registerCtl setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:registerCtl animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        scrollView.backgroundColor = Color(239, 239, 239, 1.0);
    }else{
        scrollView.backgroundColor = Color(252, 186, 0, 1.0);
    }
}

@end
