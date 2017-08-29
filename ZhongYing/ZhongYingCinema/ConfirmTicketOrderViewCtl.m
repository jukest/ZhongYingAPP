//
//  ConfirmTicketOrderViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ConfirmTicketOrderViewCtl.h"
#import "PackageTableViewCell.h"
#import "CouponViewCtl.h"
#import "PaymentViewCtl.h"
#import "RecommendTableViewCell.h"
#import "Souvenir.h"
#import "Coupon.h"
#import "RefundView.h"

@interface ConfirmTicketOrderViewCtl ()<UITableViewDelegate,UITableViewDataSource,RecommendTableViewCellDelegate,UIGestureRecognizerDelegate,RefundViewDelegate>
{
    MBProgressHUD *_HUD;
    NSInteger _time;
    NSTimer *_timer;
    UIButton *_payBtn;
    MBProgressHUD *_unlockHUD;
}
@property(nonatomic,strong) NSDictionary *film;  //!<< 当前影片信息
@property(nonatomic,strong) NSArray *goods; //!<< 订单的卖品信息
@property(nonatomic,strong) NSDictionary *price; //!<< 订单的优惠卷金额信息
@property(nonatomic,strong) NSArray *orderform; //!<< 订单的id
@property(nonatomic,strong) NSMutableArray *souvenirList; //!<< 推荐商品
@property(nonatomic,strong) NSArray *selectCou;
@property(nonatomic,copy) NSString *souvenirStr; //!<< json形式的推荐商品,例如[{"id":7,"number":1}]
@property(nonatomic,assign) NSInteger couponPrice; //!<< 优惠价格
@property(nonatomic,assign) float souvenirPrice; //!<< 推荐商品价格

@end

@implementation ConfirmTicketOrderViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"确认订单";
    [self registerLJWKeyboardHandler];
    
    _time = 8 * 60;
    self.couponPrice = 0;
    self.souvenirPrice = 0;
    
    [self loadBuyTicket];
}

- (BOOL)navigationShouldPopOnBackButton
{
    return [self canBack];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods
- (void)loadBuyTicket
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserBuyTicketURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"film_id"] = @(self.film_id);
    parameters[@"seat_id"] = self.seat_id;
    if (self.goods_info != nil) {
        parameters[@"goods_info"] = [self pictureArrayToJSON:self.goods_info];
    }
    NSLog(@"%@",parameters);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getUserBuyTicket>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            self.film = content[@"film"];
            self.goods = content[@"goods"];
            self.price = content[@"price"];
            self.orderform = content[@"orderform"];
            self.selectCou = self.price[@"coupon_id"];
            self.couponPrice = [self.price[@"diff_price"] integerValue];
            
            [self loadSouvenir];
            
        }else if ([dataBack[@"code"] integerValue] == 305501){
            [_HUD hide:YES];
            [self showHudMessage:@"座位已被锁定"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            if ([dataBack[@"message"] isEqual:[NSNull null]]) {
                [self showHudMessage:@"数据格式错误，请稍后重试"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (NSString *)pictureArrayToJSON:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}

- (void)loadSouvenir
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserSouvenirURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"film_id"] = @(self.film_id);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr
                             parameters:parameters
                                 result:^(id dataBack, NSString *currentPager) {
                                     NSLog(@"getUserSouvenir>>>>>>>>>>>%@",dataBack);
                                     if ([dataBack[@"code"] integerValue] == 0) {
                                         NSDictionary *content = dataBack[@"content"];
                                         NSError *error;
                                         if (![content[@"souvenir"] isEqual:[NSNull null]]) {
                                             Souvenir *souvenir = [[Souvenir alloc] initWithDictionary:content[@"souvenir"] error:&error];
                                             if (error) {
                                                 NSLog(@"souvenir_error=%@",error);
                                             }
                                             [self.souvenirList addObject:souvenir];
                                         }
                                         
                                         //[self.recommendTableView reloadData];
                                         [self setupConfirmOrderUI];
                                         [self showHudMessage:@"订单提交成功!"];
                                     }else if ([dataBack[@"code"] integerValue] == 305501){
                                         [_HUD hide:YES];
                                         [self showHudMessage:@"座位已被锁定"];
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                         });
                                     }else{
                                         [self showHudMessage:dataBack[@"message"]];
                                     }
                                     [_HUD hide:YES];
                                 } failure:^(NSError *error) {
                                     [self showHudMessage:@"连接服务器失败!"];
                                 }];
}

- (void)setupConfirmOrderUI
{
    CGFloat scrollH = 293;
    if (_hasSnack) {
        scrollH = 293 +56 * self.goods.count;
    }
    //NSLog(@"%f",ScreenHeight -64);
    UIView *scrollView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, scrollH) backgroundColor:Color(245, 245, 245, 1.0)];
    
    UIView *countdownView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 42) backgroundColor:Color(145, 155, 188, 1.0)];
    [scrollView addSubview:countdownView];
    
    self.countdownLb = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 180, 20)
                                                        title:@"支付剩余时间：08:00"
                                                   titleColor:[UIColor whiteColor]
                                                       target:nil
                                                       action:nil
                                                          tag:100];
    [self.countdownLb setImage:[UIImage imageNamed:@"count_down"] forState:UIControlStateNormal];
    self.countdownLb.titleLabel.font = [UIFont systemFontOfSize:15];
    self.countdownLb.center = CGPointMake(ScreenWidth / 2, 21);
    [countdownView addSubview:self.countdownLb];
    
    // 定时器
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
    //        [self timerAction];
    //    }];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode: UITrackingRunLoopMode];
    
    UIView *movieDetailsView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 42, ScreenWidth, 124) backgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:movieDetailsView];
    
    self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15, ScreenWidth -24, 20)
                                                   text:self.film[@"name"]
                                                   font:[UIFont systemFontOfSize:20]
                                              textColor:Color(26, 26, 26, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [movieDetailsView addSubview:self.nameLb];
    
    NSString *date = @"";
    NSString *d = [[NSString stringWithFormat:@"%@",self.film[@"start_time"]] transforTomyyyyMMddWithFormatter:@"MM月dd日"];
    switch ([self.film[@"time_type"] integerValue]) {
        case 1: //今天
            date = [NSString stringWithFormat:@"今天%@",d];
            break;
        case 2: //明天
            date = [NSString stringWithFormat:@"明天%@",d];
            break;
        case 3: //后天
            date = [NSString stringWithFormat:@"后天%@",d];
            break;
        default:
            break;
    }
    CGSize dateSize = [date sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15 +20 +10, dateSize.width, 15)
                                                   text:date
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(248, 109, 128, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [movieDetailsView addSubview:self.dateLb];
    
    NSString *time = [[NSString stringWithFormat:@"%@",self.film[@"start_time"]] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    CGSize timeSize = [time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +dateSize.width +15, 15 +20 +10, timeSize.width, 15)
                                                   text:time
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(248, 109, 128, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [movieDetailsView addSubview:self.timeLb];
    
    self.typeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +dateSize.width +15 +timeSize.width +12, 15 +20 +10, 200, 15)
                                                   text:[NSString stringWithFormat:@"(%@%@)",self.film[@"language"],self.film[@"tags"]]
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(150, 150, 150, 1.0)
                                              alignment:NSTextAlignmentLeft];
    NSString *str1 = @"";
    if (![self.film[@"language"] isEqual:[NSNull null]]) {
        str1 = [NSString stringWithFormat:@"%@%@",str1,self.film[@"language"]];
    }
    if (![self.film[@"tags"] isEqual:[NSNull null]]) {
        str1 = [NSString stringWithFormat:@"%@%@",str1,self.film[@"tags"]];
    }
    self.typeLb.text = [NSString stringWithFormat:@"(%@)",str1];
    [movieDetailsView addSubview:self.typeLb];
    
    NSString *cinemaName = self.cinema_name;
    CGSize cinemaSize = [cinemaName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.cinemaNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15 +20 +10 +15 +10, cinemaSize.width, 15)
                                                         text:cinemaName
                                                         font:[UIFont systemFontOfSize:15]
                                                    textColor:Color(82, 82, 82, 1.0)
                                                    alignment:NSTextAlignmentLeft];
    [movieDetailsView addSubview:self.cinemaNameLb];
    
    self.hallLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +cinemaSize.width +15, 15 +20 +10 +15 +10, 200, 15)
                                                   text:self.film[@"hall_name"]
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(82, 82, 82, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [movieDetailsView addSubview:self.hallLb];
    
    NSString *seatStr;
    NSMutableArray *seats = [NSMutableArray array];
    for (ZFSeatButton *seatButton in self.selectedSeats) {
        ZFSeatModel *seatModel = seatButton.seatmodel;
        NSInteger row = [seatModel.rowValue integerValue];
        NSInteger col = [seatModel.columnValue integerValue];
        [seats addObject:[NSString stringWithFormat:@"%zd排%zd座",row,col]];
    }
    seatStr = [seats componentsJoinedByString:@" "];
    self.seatNumberLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15 +20 +10 +15 +10 +15 +10, ScreenWidth, 15)
                                                         text:seatStr
                                                         font:[UIFont systemFontOfSize:15]
                                                    textColor:Color(82, 82, 82, 1.0)
                                                    alignment:NSTextAlignmentLeft];
    [movieDetailsView addSubview:self.seatNumberLb];
    
    //NSInteger height = 0;
    if (_hasSnack) {
        movieDetailsView.frame = CGRectMake(0, 42, ScreenWidth, 124 + 57 * self.goods.count);
        for (int i = 0; i < self.goods.count; i ++) {
            UIView *snackLine = [FanShuToolClass createViewWithFrame:CGRectMake(12, 124 + i * 57, ScreenWidth -24, 1) backgroundColor:Color(241, 241, 241, 1.0)];
            [movieDetailsView addSubview:snackLine];
            
            UILabel *snackLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 124 +5 + i * 57, ScreenWidth -24, 47)
                                                                text:[NSString stringWithFormat:@"%@\n%@",self.goods[i][@"name"],self.goods[i][@"detail"]]
                                                                font:[UIFont systemFontOfSize:15]
                                                           textColor:Color(40, 40, 40, 1.0)
                                                           alignment:NSTextAlignmentLeft];
            snackLb.numberOfLines = 0;
            //lb.attributedText = [FanShuToolClass getAttributeStringWithContent:arr[i] withLineSpaceing:5];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:snackLb.text];
            NSRange range = NSMakeRange([self.goods[i][@"name"] length] +1, [self.goods[i][@"detail"] length]);
            [str addAttributes:@{NSForegroundColorAttributeName : Color(40, 40, 40, 1.0)} range:range];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:5];
            [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, snackLb.text.length)];
            snackLb.attributedText = str;
            [movieDetailsView addSubview:snackLb];
        }
        //height = 46;
    }
    UIView *couponView;
    if ([self.goods isEqual:[NSNull null]]) {
        couponView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 42 +124 +18, ScreenWidth, 91) backgroundColor:[UIColor whiteColor]];
    }else{
        couponView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 42 +124 +self.goods.count * 56 +18, ScreenWidth, 91) backgroundColor:[UIColor whiteColor]];
    }
    [scrollView addSubview:couponView];
    
    UILabel *total = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 14, 100, 17) text:@"总价" font:[UIFont systemFontOfSize:16] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentLeft];
    [couponView addSubview:total];
    
    self.totalPriceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -12 -100, 14, 100, 17) text:[NSString stringWithFormat:@"%zd元",[self.price[@"all_price"] integerValue]] font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
    [couponView addSubview:self.totalPriceLb];
    
    NSRange range = [self.totalPriceLb.text rangeOfString:@"元"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.totalPriceLb.text];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:Color(127, 127, 127, 1.0)} range:range];
    self.totalPriceLb.attributedText = str;
    
    UIView *couponLine = [FanShuToolClass createViewWithFrame:CGRectMake(12, 45, ScreenWidth -24, 1) backgroundColor:Color(241, 241, 241, 1.0)];
    [couponView addSubview:couponLine];
    
    UILabel *coupon = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 46 +14, 100, 17) text:@"优惠券" font:[UIFont systemFontOfSize:16] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentLeft];
    [couponView addSubview:coupon];
    //559
    //605
    self.couponLb = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -12 -100, 46, 100, 45) title:[NSString stringWithFormat:@"减%zd元",self.couponPrice] titleColor:Color(247, 86, 109, 1.0) target:nil action:nil tag:111];
    self.couponLb.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.couponLb setImage:[UIImage imageNamed:@"cinema_back"] forState:UIControlStateNormal];
    [self.couponLb setImageEdgeInsets:UIEdgeInsetsMake(0, 90, 0, 0)];
    [self.couponLb setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [couponView addSubview:self.couponLb];
    
    UIView *backView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 46, ScreenWidth, 45) backgroundColor:[UIColor clearColor]];
    [couponView addSubview:backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCoupon:)];
    [backView addGestureRecognizer:tap];
    
    self.recommendTableView.tableHeaderView = scrollView;
    
    CGFloat payHeight;
    if (scrollView.frame.size.height + self.souvenirList.count * 122 +144 <= ScreenHeight -64) {
        payHeight = ScreenHeight -scrollView.frame.size.height -self.souvenirList.count * 122 -64;
    }else{
        payHeight = 144;
    }
    UIView *payView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 46, ScreenWidth, payHeight) backgroundColor:[UIColor whiteColor]];
    
    self.finalPaymentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -15 -200, 15, 200, 20) text:[NSString stringWithFormat:@"还需支付：%.0f元",([self.price[@"all_price"] floatValue] -self.couponPrice +self.souvenirPrice) > 0 ? [self.price[@"all_price"] floatValue] -self.couponPrice +self.souvenirPrice : 0] font:[UIFont systemFontOfSize:16] textColor:Color(247, 86, 109, 1.0) alignment:NSTextAlignmentRight];
    [payView addSubview:self.finalPaymentLb];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.finalPaymentLb.text];
    NSRange strRange = [self.finalPaymentLb.text rangeOfString:@"还需支付："];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
    self.finalPaymentLb.attributedText = attributeStr;
    
    UIButton *payBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(20, payHeight -44 -50, ScreenWidth -40, 50) title:@"确认支付" titleColor:[UIColor whiteColor] target:self action:@selector(ConfirmTicketOrderViewEvents:) tag:112];
    payBtn.backgroundColor = Color(252, 186, 0, 1.0);
    payBtn.layer.cornerRadius = 3.0f;
    payBtn.layer.masksToBounds = YES;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [payView addSubview:payBtn];
    _payBtn = payBtn;
    
    self.recommendTableView.tableFooterView = payView;
}

- (void)timerAction
{
    if (_time != 0) {
        _time --;
        [self.countdownLb setTitle:[[NSString stringWithFormat:@"%zd",_time] transforTomyyyyMMddWithFormatter:@"支付剩余时间：mm:ss"] forState:UIControlStateNormal];
        if (_time == 0) {
            UIViewController *vc = self.navigationController.viewControllers[2];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }else{
        [_timer invalidate];
    }
}

#pragma mark - 懒加载
- (UITableView *)recommendTableView
{
    if (_recommendTableView == nil) {
        _recommendTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_recommendTableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"RecommendTableViewCell"];
        [self.view addSubview:_recommendTableView];
    }
    return _recommendTableView;
}

- (NSMutableArray *)souvenirList
{
    if (_souvenirList == nil) {
        _souvenirList = [NSMutableArray array];
    }
    return _souvenirList;
}

#pragma mark - View Handles
- (void)gotoCoupon:(UIGestureRecognizer *)tap
{
    // 优惠券
    CouponViewCtl *coupon = [[CouponViewCtl alloc] init];
    coupon.hasSnack = self.hasSnack;
    coupon.hasTicket = YES;
    coupon.coupon_ids = self.selectCou;
    __weak ConfirmTicketOrderViewCtl *weak = self;
    coupon.block = ^void(NSArray *coupons){
        self.couponPrice = 0;
        NSMutableArray *couponArr = [NSMutableArray array];
        for (Coupon *c in coupons) {
            self.couponPrice = self.couponPrice +[c.price integerValue];
            [couponArr addObject:c.id];
        }
        [weak.couponLb setTitle:[NSString stringWithFormat:@"减%zd元",self.couponPrice] forState:UIControlStateNormal];
        weak.finalPaymentLb.text = [NSString stringWithFormat:@"还需支付：%.0f元",([self.price[@"last_price"] floatValue] -self.couponPrice +self.souvenirPrice) > 0 ? [self.price[@"last_price"] floatValue] -self.couponPrice +self.souvenirPrice : 0];
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.finalPaymentLb.text];
        NSRange strRange = [self.finalPaymentLb.text rangeOfString:@"还需支付："];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
        self.finalPaymentLb.attributedText = attributeStr;
        
        weak.selectCou = couponArr;
    };
    [coupon setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:coupon animated:YES];
}

- (void)ConfirmTicketOrderViewEvents:(UIButton *)btn
{
    if (btn.tag == 112){
        // 确认支付
        PaymentViewCtl *payment = [[PaymentViewCtl alloc] init];
        payment.orderform_id = [self.orderform componentsJoinedByString:@","];
        if (self.selectCou.count != 0) {
            payment.coupon_id = [self.selectCou componentsJoinedByString:@","];
        }else{
            payment.coupon_id = nil;
        }
        payment.seat_id = self.seat_id;
        payment.film_id = self.film_id;
        payment.seats = self.seatNumberLb.text;
        payment.goods = [self pictureArrayToJSON:self.souvenirStr];
        payment.isTicket = YES;
        [payment setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:payment animated:YES];
    }
}

#pragma mark - RefundViewDelegate
- (void)gotoRefundViewEvents:(NSInteger)tag
{
    _unlockHUD = [FanShuToolClass  createMBProgressHUDWithText:@"座位解锁中..." target:self];
    [self.view addSubview:_unlockHUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserUnlockURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getUnlock>>>>>>>>>>>>>>>>>>>>>%@",dataBack);
        NSDictionary *content = dataBack[@"content"];
        if ([dataBack[@"code"] integerValue] == 0) {
            if ([content[@"result"] boolValue]) {
                
                NSLog(@"解锁成功!");
            }
        }else{
            NSLog(@"%@",dataBack[@"message"]);
        }
        [_timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
        [_unlockHUD hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"连接服务器失败!error = %@",error);
        [self showHudMessage:@"解锁失败!"];
        [_unlockHUD hide:YES];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return [self canBack];
}

- (BOOL)canBack
{
    NSString *content = @"返回后，您当前选中的座位将不再保留";
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
    return NO;
}

#pragma mark - RecommendTableViewCellDelegate
- (void)gotoRecommendAmountChanged:(NSInteger)amount indexPath:(NSIndexPath *)index
{
    NSLog(@"amount = %zd,index = %@",amount,index);
    Souvenir *souvenir = self.souvenirList[index.row];
    if (amount == 0) {
        self.souvenirStr = nil;
        self.souvenirPrice = 0;
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"id"] = souvenir.id;
        dict[@"number"] = @(amount);
        NSArray *sou = @[dict];
        NSData *data = [NSJSONSerialization dataWithJSONObject:sou options:NSJSONWritingPrettyPrinted error:nil];
        self.souvenirStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.souvenirPrice = amount * [souvenir.price floatValue];
    }
    self.finalPaymentLb.text = [NSString stringWithFormat:@"还需支付：%.0f元",([self.price[@"last_price"] floatValue] -self.couponPrice +self.souvenirPrice) > 0 ? [self.price[@"last_price"] floatValue] -self.couponPrice +self.souvenirPrice : 0];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.finalPaymentLb.text];
    NSRange strRange = [self.finalPaymentLb.text rangeOfString:@"还需支付："];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
    self.finalPaymentLb.attributedText = attributeStr;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.souvenirList.count != 0) {
        return 37;
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.souvenirList.count != 0) {
        UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 37) backgroundColor:[UIColor whiteColor]];
        UILabel *recommendLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 14, 200, 17) text:@"推荐优惠商品" font:[UIFont systemFontOfSize:16] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentLeft];
        [view addSubview:recommendLb];
        return view;
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.souvenirList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Souvenir *souvenir = self.souvenirList[indexPath.row];
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell"];
    [cell configCellWithModel:souvenir];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath;
    cell.delegate = self;
    return cell;
}

@end
