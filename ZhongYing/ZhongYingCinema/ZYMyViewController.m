//
//  ZYMyViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMyViewController.h"
#import "MyLoginView.h"
#import "MyView.h"
#import "LoginViewController.h"
#import "RegisterViewCtl.h"
#import "RechargeViewController.h"
#import "MyInformationViewCtl.h"
#import "ZYMyUpListView.h"
#import "ZYMoreListView.h"
#import "RefundView.h"
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
#import "ZYMemberViewController.h"


// 最上面视图高度
#define HEIGHT_MyView 230
// 最上面没有登录视图高度
#define HEIGHT_MyLoginView 120


@interface ZYMyViewController ()<MyViewDelegate,MyLoginViewDelegate,UIScrollViewDelegate,RefundViewDelegate,ZYMoreListViewDelegate,ZYMyUpListViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) MyView *myInfoHeaderView;

@property (nonatomic, strong) MyLoginView *myLoginHeaderView;

/** 头部列表的图标数据源 */
@property (nonatomic, strong) NSArray *upListImgData;
/** 头部列表的标题数据源 */
@property (nonatomic, strong) NSArray *upListTitleData;

/** 更多列表的图标数据源 */
@property (nonatomic, strong) NSArray *moreListImgData;
/** 更多列表的标题数据源 */
@property (nonatomic, strong) NSArray *moreListTitleData;

/** ZYUplistView */
@property (nonatomic, strong) ZYMyUpListView *uplistView;

@property (nonatomic, strong) UIView *lineViwe;

@property (nonatomic, strong) ZYMoreListView *moreListView;

@property (nonatomic, strong) UIView *logoutView;

@property (nonatomic, strong) UIButton *logoutBtn;
@end

@implementation ZYMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addStatusView];
    
    [self addRefreshView];
    
    [self addUpList];
    
    [self.scrollView addSubview:self.lineViwe];
    
    [self addMoreList];
    
    [self.scrollView addSubview:self.logoutView];

}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 隐藏导航栏[解决导航栏问题两个方法中实现1、viewWillAppear；2、viewWillDisappear]
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 每次刚开始的时候刷新tableHeaderView
    [self.myInfoHeaderView removeFromSuperview];
    [self.myLoginHeaderView removeFromSuperview];
    [self addHeaderView];
    [self showLogoutBtn];
    [self layoutSubViews];
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

#pragma mark -- 初始化

- (void)showLogoutBtn {
    if ([LoginYesOrNoStr isEqualToString:@"YES"]) {
        self.logoutBtn.hidden = NO;
    } else {
        self.logoutBtn.hidden = YES;
    }
}

- (void)addUpList{
    [self.scrollView addSubview:self.uplistView];
}

- (void)addMoreList {
    [self.scrollView addSubview:self.moreListView];
}

- (void)addHeaderView {
    
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {// 如果在没有登入的情况
        [self.scrollView addSubview:self.myLoginHeaderView];
    }else {
        [self.scrollView addSubview:self.myInfoHeaderView];
    }
}

// 刷新实现
- (void)addRefreshView{
    __weak typeof(self) weakSelf = self;
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([LoginYesOrNoStr isEqualToString:@"YES"]) {
            [weakSelf loadMyself];
        }else{
            [weakSelf.scrollView.mj_header endRefreshing];
        }
    }];
    MJRefreshNormalHeader *h = (MJRefreshNormalHeader *)self.scrollView.mj_header;
    h.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    h.stateLabel.textColor = [UIColor whiteColor];
}

- (void)addStatusView{
    // 设置状态栏的背景色
    UIView *topStatusView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 20) backgroundColor:Color(252, 186, 0, 1.0)];
    [self.view addSubview:topStatusView];
}

#pragma mark -- 懒加载

- (UIView *)logoutView {
    if (!_logoutView) {
        _logoutView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moreListView.frame), ScreenWidth,self.scrollView.contentSize.height - CGRectGetMaxY(self.moreListView.frame))];
        _logoutView.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *loginOutBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12, 30, self.view.width -24, 50) title:@"退出登录" titleColor:[UIColor whiteColor] cornerRadius:3.0 font:[UIFont systemFontOfSize:18] backgroundColor:Color(252, 186, 0, 1.0) target:self action:@selector(logoutBtnAction:) tag:13];
        self.logoutBtn = loginOutBtn;
        [_logoutView addSubview:loginOutBtn];
        
    }
    return _logoutView;
}

- (ZYMoreListView *)moreListView {
    if (!_moreListView) {
        _moreListView = [[ZYMoreListView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineViwe.frame), ScreenWidth, 300) withImgs:self.moreListImgData withTitles:self.moreListTitleData];
        _moreListView.delegate = self;
    }
    return _moreListView;
}

- (UIView *)lineViwe {
    if (!_lineViwe) {
        _lineViwe = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.uplistView.frame), ScreenWidth, 20)];
        _lineViwe.backgroundColor = Color(239,239 , 239, 1);
    }
    return _lineViwe;
}

- (ZYMyUpListView *)uplistView {
    if (!_uplistView) {
        CGFloat y = 0;
        
        if ([LoginYesOrNoStr isEqualToString:@"YES"]) {
            y = HEIGHT_MyView;
        } else {
            y = HEIGHT_MyLoginView;
        }
        
        _uplistView = [[ZYMyUpListView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 60) withImgs:self.upListImgData withTitles:self.upListTitleData];
        _uplistView.delegate = self;
    }
    return _uplistView;
}

- (NSArray *)upListImgData {
    if (!_upListImgData) {
        _upListImgData = @[@"my_order",@"memberCard",@"my_news",@"my_not_evaluate"];
    }
    return _upListImgData;
}

- (NSArray *)upListTitleData {
    if (!_upListTitleData) {
        _upListTitleData = @[@"我的订单",@"会员卡",@"我的消息",@"待评价"];
    }
    return _upListTitleData;
}

- (NSArray *)moreListImgData {
    if (!_moreListImgData) {
        _moreListImgData = @[@"my_0_0",@"my_0_1",@"my_1_0",@"my_0_3",@"my_0_4",@"my_1_2",@"my_1_3"];
    }
    return _moreListImgData;

}

- (NSArray *)moreListTitleData {
    if (!_moreListTitleData) {
        _moreListTitleData = @[@"我的账单",@"我的影评",@"关注影院",@"我的收藏",@"我的评论",@"反馈统计",@"关于我们"];
    }
    return _moreListTitleData;
}

- (MyLoginView *)myLoginHeaderView {
    if (!_myLoginHeaderView) {
        _myLoginHeaderView = [[MyLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT_MyLoginView)];
        _myLoginHeaderView.delegate = self;
    }
    return _myLoginHeaderView;
}

- (MyView *)myInfoHeaderView {
    if (!_myInfoHeaderView) {
        _myInfoHeaderView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT_MyView)];
        _myInfoHeaderView.delegate = self;
    }
    return _myInfoHeaderView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 49 - 20)];
        _scrollView.backgroundColor = Color(252, 186, 0, 1.0);
        _scrollView.contentSize = CGSizeMake(0, 750);
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}

#pragma mark -- 网络请求
- (void)loadMyself
{    __weak typeof(self) weakSelf = self;

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMyselfURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if (weakSelf.scrollView.mj_header.isRefreshing) {
            [weakSelf.scrollView.mj_header endRefreshing];
        }
        NSLog(@"getMyself>>>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            [self.myInfoHeaderView configMyViewWithContent:content];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",[content[@"balance"][@"remain"] floatValue]] forKey:@"myremain"];// 余额
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",[content[@"balance"][@"score"] integerValue]] forKey:@"myscore"];// 积分
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",[content[@"comment"] integerValue]] forKey:@"mycomment"];// 评论
            self.uplistView.comment = [NSString stringWithFormat:@"%zd",[content[@"comment"] integerValue]];
            
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        if (self.scrollView.mj_header.isRefreshing) {
            [self.scrollView.mj_header endRefreshing];
        }
        [self showHudMessage:@"连接服务器失败!"];
    }];
}


#pragma mark -- MyLoginViewDelegate

- (void)MyLoginViewClickWithTag:(NSInteger)tag {
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


#pragma mark - MyViewDelegate
- (void)MyViewDelegateWithTag:(NSInteger)tag{
    if (tag == 100) {
        // 前往充值
        RechargeViewController *rechargeCtl = [[RechargeViewController alloc] init];
        [rechargeCtl setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:rechargeCtl animated:YES];
    }else if (tag == 101) {
        // 前往我的账单
//        MyOrderViewCtl *myOrder = [[MyOrderViewCtl alloc] init];
//        myOrder.isFromPayMent = NO;
//        [myOrder setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:myOrder animated:YES];
    }else if (tag == 102) {
        // 前往待评价
//        EvaluateViewCtl *evaluate = [[EvaluateViewCtl alloc] init];
//        [evaluate setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:evaluate animated:YES];
    }
}

- (void)MyViewDelegateClickHead{
    // 前往我的资料
    MyInformationViewCtl *myInformation = [[MyInformationViewCtl alloc] init];
    [myInformation setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:myInformation animated:YES];
}

- (void)logoutBtnAction:(UIButton *)sender {
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
    
    self.uplistView.comment = nil;
    [self.myInfoHeaderView removeFromSuperview];
    [self.myLoginHeaderView removeFromSuperview];
    [self addHeaderView];
    [self showLogoutBtn];
    [self layoutSubViews];
    
    
    //发送通知 退出登录
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];

    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)layoutSubViews {
    
    CGFloat y = 0;
    if ([LoginYesOrNoStr isEqualToString:@"YES"]) {
        y = HEIGHT_MyView;
    } else {
        y = HEIGHT_MyLoginView;
    }

    self.uplistView.frame = CGRectMake(0, y, ScreenWidth, self.uplistView.height);
    self.lineViwe.frame = CGRectMake(0, CGRectGetMaxY(self.uplistView.frame), ScreenWidth, self.lineViwe.height);
    self.moreListView.frame = CGRectMake(0, CGRectGetMaxY(self.lineViwe.frame), ScreenWidth, self.moreListView.height);
    self.logoutView.frame = CGRectMake(0, CGRectGetMaxY(self.moreListView.frame), ScreenWidth, self.logoutView.height);
    if ([LoginYesOrNoStr isEqualToString:@"YES"]) {
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.logoutView.frame));
    } else {
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.moreListView.frame));
    
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

#pragma mark -- ZYMoreListViewDelegate
- (void)moreListView:(ZYMoreListView *)moreListView buttonDidClick:(UIButton *)button {
    if ( ![LoginYesOrNoStr isEqualToString:@"YES"]) {
        [(ZYNavigationController *)self.navigationController showLoginViewController];
    } else {
        
        if (button.tag == MyBill) {//我的账单
            MyBillViewController *myBill = [[MyBillViewController alloc] init];
            [myBill setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myBill animated:YES];
        } else if (button.tag == MyFilmCritic) {//我的影评
            MyReviewViewCtl *myReview = [[MyReviewViewCtl alloc] init];
            [myReview setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myReview animated:YES];
        } else if (button.tag == AttentionCinema) {//关注影院
            MoreCinemaViewCtl *concernCinema = [[MoreCinemaViewCtl alloc] init];
            concernCinema.cinemaType = @"关注影院";
            [concernCinema setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:concernCinema animated:YES];
        } else if (button.tag == MyLove) {//我的收藏
            MyCollectionViewCtl *myCollection = [[MyCollectionViewCtl alloc] init];
            [myCollection setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myCollection animated:YES];
        } else if (button.tag == MyComment){//我的评论
            MyCommentViewCtl *myComment = [[MyCommentViewCtl alloc] init];
            [myComment setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myComment animated:YES];

        } else if (button.tag == SuggestedStatistics) {//反馈统计
            ComplaintViewCtl *complaint = [[ComplaintViewCtl alloc] init];
            [complaint setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:complaint animated:YES];
        } else if (button.tag == AboutUS) {//关于我们
            AboutUsViewCtl *aboutUs = [[AboutUsViewCtl alloc] init];
            [aboutUs setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
        
    }
}

#pragma mark -- ZYMyUpListViewDelegate
- (void)myUpListView:(ZYMyUpListView *)myupListView buttonDidClick:(UIButton *)button {
    if ( ![LoginYesOrNoStr isEqualToString:@"YES"]) {
        [(ZYNavigationController *)self.navigationController showLoginViewController];
    } else {
        
        if (button.tag == MyOrder) {//我的订单
            // 前往我的账单
            MyOrderViewCtl *myOrder = [[MyOrderViewCtl alloc] init];
            myOrder.isFromPayMent = NO;
            [myOrder setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myOrder animated:YES];
            
        } else if(button.tag == MyCoupon) {//会员卡
            ZYMemberViewController *coupon = [[ZYMemberViewController alloc] init];
            coupon.title = @"会员卡";
            [coupon setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:coupon animated:YES];
            
        } else if (button.tag == MyNews){//我的消息
            
            MyMessageViewCtl *myMessage = [[MyMessageViewCtl alloc] init];
            [myMessage setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myMessage animated:YES];
            
        } else if (button.tag == NoComment) {//待评论
            // 前往待评价
            EvaluateViewCtl *evaluate = [[EvaluateViewCtl alloc] init];
            [evaluate setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:evaluate animated:YES];
        }
    }
}

@end
