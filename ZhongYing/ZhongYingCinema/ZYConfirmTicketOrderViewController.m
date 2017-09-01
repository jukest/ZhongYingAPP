//
//  ZYConfirmTicketOrderViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYConfirmTicketOrderViewController.h"
#import "FanShuToolClass.h"

@interface ZYConfirmTicketOrderViewController ()
/** 状态栏黄色背景视图 */
@property (nonatomic, strong) UIView *statusBarbackgroundView;

/** 头部视图 */
@property (nonatomic, strong) UIView *headerView;


/**
 返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/** 倒计时label */
@property (nonatomic, strong) UILabel *timeLabel;

/** 影片名 */
@property (nonatomic, strong) UILabel *cinemaNameLabel;

/** 影院名 */
@property (nonatomic, strong) UILabel *hallLb;

/** 播放时间 */
@property (nonatomic, strong) UILabel *playTimeLabel;

/** 座位 */
@property (nonatomic, strong) UILabel *seatLabel;

/** 美食套餐 */
@property (nonatomic, strong) UILabel *foodLabel;

/** 总价 */
@property (nonatomic, strong) UILabel *totalMoneyLabel;

/** 优惠价 */
@property (nonatomic, strong) UILabel *couponLabel;

/** 还需支付 */
@property (nonatomic, strong) UILabel *payLabel;



/** 手机号 */
@property (nonatomic, strong) UIButton *telephoneLabel;




@end

@implementation ZYConfirmTicketOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color(235, 235, 236, 1.0);
    self.hasSnack = YES;
    [self setupUI];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- 初始化

- (void)setupUI {
    [self setupStatusBarBackground];
    
    [self setupHeader];
    [self setupMidelContent];
}

- (void)setupMidelContent {
    CGFloat y = CGRectGetMaxY(self.headerView.frame) + ZYConfirmTicketOrderViewControllerMidellContentTopMarge * heightFloat;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, y , ScreenWidth, 400)];
    backgroundView.backgroundColor = Color(228, 228, 230, 1);
    [self.view addSubview:backgroundView];
    
    //电影名
    y = 30;
    UILabel *cinemaNameLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight * heightFloat) text:@"加列比海盗5:死无对证" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    [backgroundView addSubview:cinemaNameLabel];
    self.cinemaNameLabel = cinemaNameLabel;
    
    //影院名
    y = CGRectGetMaxY(cinemaNameLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5 * heightFloat;
    UILabel *hallLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight *heightFloat) text:@"深圳中影泰德影城龙岗店 7号厅" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerSmallFont] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter];
    self.hallLb = hallLabel;
    [backgroundView addSubview:hallLabel];
    
    //分割线
    y = CGRectGetMaxY(hallLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;
    CGRect frame2 = CGRectMake(ZYConfirmTicketOrderViewControllerLeftRigthMarge, y, ScreenWidth - 2 * ZYConfirmTicketOrderViewControllerLeftRigthMarge, 2);
    UIView *lineView2 = [self lineViewWithFrame:frame2];
    [backgroundView addSubview:lineView2];
    
    //播放时间
    y = CGRectGetMaxY(lineView2.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;
    UILabel *timeLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight) text:@"时间" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerSmallFont] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter];
    [backgroundView addSubview:timeLabel];
    
    y = CGRectGetMaxY(timeLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
    UILabel *playTimeLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight) text:@"2017-05-23 周四 18:20" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.playTimeLabel = playTimeLabel;
    [backgroundView addSubview:playTimeLabel];
    
    //座位
    y = CGRectGetMaxY(playTimeLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;
    UILabel *seatLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight) text:@"座位" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerSmallFont] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter];
    [backgroundView addSubview:seatLb];
    
    y = CGRectGetMaxY(seatLb.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
    UILabel *seatLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight) text:@"D排03座 D排03座" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.seatLabel = seatLabel;
    [backgroundView addSubview:seatLabel];
    
    //分割线
    y = CGRectGetMaxY(seatLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;
    CGRect frame3 = CGRectMake(ZYConfirmTicketOrderViewControllerLeftRigthMarge, y, ScreenWidth - 2 * ZYConfirmTicketOrderViewControllerLeftRigthMarge, 2);
    UIView *lineView3 = [self lineViewWithFrame:frame3];
    [backgroundView addSubview:lineView3];
    
    y = CGRectGetMaxY(lineView3.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;

    if (self.hasSnack) {//有美食
        
        //美食
        y = CGRectGetMaxY(lineView3.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;
        UILabel *foodName = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight) text:@"美食套餐" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerSmallFont] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter];
        [backgroundView addSubview:foodName];
        
        y = CGRectGetMaxY(foodName.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
        UILabel *foodLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight) text:@"中爆米花 中可乐 x1" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        self.foodLabel = foodLabel;
        [backgroundView addSubview:foodLabel];
        
        y = CGRectGetMaxY(foodLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;
        CGRect frame4 = CGRectMake(ZYConfirmTicketOrderViewControllerLeftRigthMarge, y, ScreenWidth - 2 * ZYConfirmTicketOrderViewControllerLeftRigthMarge, 2);
        UIView *lineView4 = [self lineViewWithFrame:frame4];
        [backgroundView addSubview:lineView4];
        
        y = CGRectGetMaxY(lineView4.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat;

    } else {
        
    }
    
    //总价
    UILabel *moneyLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight) text:@"总价" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerSmallFont] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter];
    [backgroundView addSubview:moneyLabel];
    
    y = CGRectGetMaxY(moneyLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
    UILabel *totalMoney = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight) text:@"100元" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.totalMoneyLabel = totalMoney;
    [backgroundView addSubview:totalMoney];
    
    y = CGRectGetMaxY(totalMoney.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
    
    
    //优惠券
    UILabel *couponNameLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight) text:@"优惠券" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerSmallFont] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter];
    [backgroundView addSubview:couponNameLabel];
    
    y = CGRectGetMaxY(couponNameLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
    UILabel *couponLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight) text:@"减80元" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.couponLabel = couponLabel;
    [backgroundView addSubview:couponLabel];
    
    y = CGRectGetMaxY(couponLabel.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
    
    //还需支付
    UILabel *payName = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight) text:@"还需支付" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerSmallFont] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentCenter];
    [backgroundView addSubview:payName];
    
    y = CGRectGetMaxY(payName.frame) + ZYConfirmTicketOrderViewControllerMarge * 0.5;
    UILabel *payLaebel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, ScreenWidth, ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight) text:@"20元" font:[UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.payLabel = payLaebel;
    [backgroundView addSubview:payLaebel];
    
    
    
    
}

- (void)setupHeader {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(ZYConfirmTicketOrderViewControllerLeftRigthMarge, ZYConfirmTicketOrderViewControllerHeaderMarge, ScreenWidth - 2 * ZYConfirmTicketOrderViewControllerLeftRigthMarge,(ZYConfirmTicketOrderViewControllerHeaderBigLabelHeight + ZYConfirmTicketOrderViewControllerHeaderSmallLabelHeight + 2 * ZYConfirmTicketOrderViewControllerMarge + 2)*heightFloat)];
    [self.view addSubview:view];
    self.headerView = view;
//    view.backgroundColor = [UIColor redColor];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, ZYConfirmTicketOrderViewControllerHeaderBigLabelHeight*heightFloat);
    [backBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(bakAction:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    
    //页面标题
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(backBtn.width,0 , view.width - 2 * backBtn.width, ZYConfirmTicketOrderViewControllerHeaderBigLabelHeight * heightFloat)];
    title.text = @"订单详情";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:24 ];
    [view addSubview:title];
    
    //分割线
    CGRect frame1 = CGRectMake(0, (CGRectGetMaxY(title.frame)) + ZYConfirmTicketOrderViewControllerMarge * heightFloat, view.width, 2);
    UIView *lineView1 = [self lineViewWithFrame:frame1];
    [view addSubview:lineView1];
    
    //倒计时label
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView1.frame) + ZYConfirmTicketOrderViewControllerMarge * heightFloat , view.width, ZYConfirmTicketOrderViewControllerHeaderSmallLabelHeight * heightFloat)];
    timeLabel.text = @"距离支付时间还剩 08:00";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = Color(148, 148, 150, 1);
    timeLabel.font = [UIFont systemFontOfSize:ZYConfirmTicketOrderViewControllerBigFont ];
    [view addSubview:timeLabel];
    
    
    
    
}


- (void)setupStatusBarBackground {
    UIView *statusBarbackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:statusBarbackgroundView];
    statusBarbackgroundView.backgroundColor = Color(252, 186, 0, 1.0);
    self.statusBarbackgroundView = statusBarbackgroundView;
    
}

- (UIView *)lineViewWithFrame:(CGRect)frame {
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = Color(252, 186, 0, 1.0);
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width * 0.5, frame.size.height)];
    view1.backgroundColor = [UIColor blackColor];
    [view addSubview:view1];
    view1.center = CGPointMake(view.width * 0.5 , view.height * 0.5);
    
    return view;
}


#pragma mark -- 按钮点击事件
- (void)bakAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
