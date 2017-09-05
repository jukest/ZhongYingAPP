//
//  ZYConfirmTicketOrderViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYConfirmTicketOrderViewController.h"
#import "FanShuToolClass.h"
#import "ZYConfirmOrderTableViewHeader.h"
#import "PackageTableViewCell.h"
#import "Souvenir.h"
#import "ZYConfirmOrderTableViewHeader.h"
#import "CouponViewCtl.h"
#import "RefundView.h"
#import "Coupon.h"
#import "PaymentViewCtl.h"

@interface ZYConfirmTicketOrderViewController ()<UITableViewDelegate,UITableViewDataSource,RefundViewDelegate,PackageTableViewCellDelegate>{
    MBProgressHUD *_HUD;
    NSInteger _time;
    UIButton *_payBtn;
    MBProgressHUD *_unlockHUD;
}

@property (nonatomic, strong) ZYConfirmOrderTableViewHeader *header;
@property (nonatomic, strong)UITableView *tableView;

@property(nonatomic,strong) NSArray *goods; //!<< 订单的卖品信息
@property(nonatomic,strong) NSDictionary *price; //!<< 订单的优惠卷金额信息
@property(nonatomic,strong) NSArray *orderform; //!<< 订单的id
@property(nonatomic,strong) NSMutableArray *souvenirList; //!<< 推荐商品
@property(nonatomic,strong) NSArray *selectCou;
@property(nonatomic,copy) NSString *souvenirStr; //!<< json形式的推荐商品,例如[{"id":7,"number":1}]
@property(nonatomic,assign) NSInteger couponPrice; //!<< 优惠价格
@property(nonatomic,assign) float souvenirPrice; //!<< 推荐商品价格


@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, strong) NSMutableArray *selecteGoods;

@property (nonatomic, strong) NSTimer *timer;

/** 导航栏下边的黑线 */
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;


/** 手机号 */
@property (nonatomic, strong) UIButton *telephoneLabel;


@property (nonatomic, strong) UIView *footerView;
/** 还需支付 */
@property (nonatomic, strong) UILabel *totalMoneyLabel;
/** payBtn */
@property (nonatomic, strong) UIButton *payBtn;


@end

@implementation ZYConfirmTicketOrderViewController

- (UIImageView *)navBarHairlineImageView {
    if (!_navBarHairlineImageView) {
        _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    return _navBarHairlineImageView;
}

- (NSMutableArray *)selecteGoods {
    if (!_selecteGoods) {
        _selecteGoods = [NSMutableArray arrayWithCapacity:10];
    }
    return _selecteGoods;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 2)];
        lineView.backgroundColor = Color(247, 247, 247, 1);
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:lineView];
    }
    return _footerView;
}

- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray arrayWithCapacity:10];
    }
    return _goodsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.view.backgroundColor = Color(235, 235, 236, 1.0);
    self.hasSnack = YES;
    [self setupUI];
    _time = 8 * 60;
    self.couponPrice = 0;

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    ZYConfirmOrderTableViewHeader *header = [[ZYConfirmOrderTableViewHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    self.tableView.tableHeaderView = header;
    self.header = header;

//    [self loadBuyTicket];
    
    [self loadGoods];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.navBarHairlineImageView.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
       
    //去掉透明后导航栏下边的黑边
    self.navBarHairlineImageView.hidden = YES;
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


#pragma mark -- 初始化

- (void)setupUI {
    
    [self setupFooterView];
    
    
    
//    [self setupStatusBarBackground];
    
//    [self setupHeader];
//    [self setupMidelContent];
}

- (void)setupFooterView{
    [self.view addSubview:self.footerView];
    
    //totalmoney
    UILabel *label = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 0, ScreenWidth - 100 - 20, self.footerView.height) text:@"还需支付 100元" font:[UIFont systemFontOfSize:15] textColor:[UIColor redColor] alignment:NSTextAlignmentLeft];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSRange strRange = [label.text rangeOfString:@"还需支付"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
    label.attributedText = attributeStr;
    [self.footerView addSubview:label];
    self.totalMoneyLabel = label;
    
    self.payBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(20+label.width, 0, 100, self.footerView.height) title:@"立即支付" titleColor:[UIColor whiteColor] target:self action:@selector(payBtnAction:) tag:100];
    self.payBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.payBtn.backgroundColor = Color(252, 186, 0, 0.9);
    [self.footerView addSubview:self.payBtn];
    
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[PackageTableViewCell class] forCellReuseIdentifier:@"PackageTableViewCell"];
        
        _tableView.tableFooterView = [UIView new];
        
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        
        return self.goodsList.count;
    }
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = [UIColor redColor];

        if (indexPath.row == 0) {
            cell.textLabel.text = @"优惠券";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"减%zd元",self.couponPrice];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"票价";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd元",[self.film[@"market_price"] integerValue] * self.selectedSeats.count];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
        
        
    } else {
        Goods *goods = self.goodsList[indexPath.row];
        PackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageTableViewCell"];
        [cell configCellWithModel:goods];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.index = indexPath;
        cell.selectBtn.hidden = YES;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 35;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 80;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        
        UILabel *label = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 5, ScreenWidth, 20) text:@"选购美食" font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [backgroundView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, backgroundView.height - 2, label.width, 2)];
        lineView.backgroundColor = Color(245, 245, 245, 1);
        [backgroundView addSubview:lineView];
        
        label.backgroundColor = [UIColor whiteColor];
        return backgroundView;
    }
    return nil;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 优惠券
            CouponViewCtl *coupon = [[CouponViewCtl alloc] init];
            coupon.hasSnack = self.hasSnack;
            coupon.hasTicket = YES;
            coupon.coupon_ids = self.selectCou;
            __weak typeof(self) weak = self;
            coupon.block = ^void(NSArray *coupons){
                self.couponPrice = 0;
                NSMutableArray *couponArr = [NSMutableArray array];
                for (Coupon *c in coupons) {
                    self.couponPrice = self.couponPrice +[c.price integerValue];
                    [couponArr addObject:c.id];
                }
//                [weak.couponLb setTitle:[NSString stringWithFormat:@"减%zd元",self.couponPrice] forState:UIControlStateNormal];
//                weak.finalPaymentLb.text = [NSString stringWithFormat:@"还需支付：%.0f元",([self.price[@"all_price"] floatValue] -self.couponPrice +self.souvenirPrice) > 0 ? [self.price[@"all_price"] floatValue] -self.couponPrice +self.souvenirPrice : 0];
                [weak.tableView reloadData];
                [weak setTotalMoney];
//                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.finalPaymentLb.text];
//                NSRange strRange = [self.finalPaymentLb.text rangeOfString:@"还需支付："];
//                [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
//                self.finalPaymentLb.attributedText = attributeStr;
                
                weak.selectCou = couponArr;
            };
            [coupon setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:coupon animated:YES];
        }
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
        [_unlockHUD hideAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"连接服务器失败!error = %@",error);
        [self showHudMessage:@"解锁失败!"];
        [_unlockHUD hideAnimated:YES];
    }];
}


#pragma mark - Help Methods

- (void)loadGoods
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonGoodsURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"group_id"] = ApiGroup_ID;
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
    }
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getGoods>>>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"goods"]) {
                
                Goods *goods = [Goods mj_objectWithKeyValues:dict];
                
                [self.goodsList addObject:goods];
            }
            
                if (self.goodsList.count != 0) {
                    [self setTotalMoney];
                    [self.header setUpFilmInfo:self.film withCinema_name:self.cinema_name withSelectSeat:self.selectedSeats];
                    
                    [self.tableView reloadData];


                }
            }
        
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)loadBuyTicket
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserBuyTicketURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"film_id"] = @(self.film_id);
    parameters[@"seat_id"] = self.seat_id;
   
   
    
    NSMutableArray *goods = [NSMutableArray arrayWithCapacity:10];
    

    for (int i = 0; i < self.goodsList.count; i++) {
        Goods *good = self.goodsList[i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        if (good.selectedNumber != 0) {
            
            dict[@"id"] = @(good.id);
            dict[@"number"] = @(good.selectedNumber);
            [goods addObject:dict];
        }
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:goods options:NSJSONWritingPrettyPrinted error:nil];
    NSString *goods_info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.goods_info = goods_info;
    
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
//            self.selectCou = self.price[@"coupon_id"];
//            self.couponPrice = [self.price[@"diff_price"] integerValue];
            
            [self loadSouvenir];
//            [self loadGoods];

            
        }else if ([dataBack[@"code"] integerValue] == 305501){
            [_HUD hideAnimated:YES];
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
        
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
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
//                                             [self.souvenirList addObject:souvenir];
                                         }
                                        
                                         [self showHudMessage:@"订单提交成功!"];
                                         
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             [self goPay];
                                         });
                                         
//                                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
//                                         
//                                         self.timer = timer;
//                                         [[NSRunLoop mainRunLoop] addTimer:timer forMode: UITrackingRunLoopMode];


                                     }else if ([dataBack[@"code"] integerValue] == 305501){
                                         [_HUD hideAnimated:YES];
                                         [self showHudMessage:@"座位已被锁定"];
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                         });
                                     }else{
                                         [self showHudMessage:dataBack[@"message"]];
                                     }
                                     [_HUD hideAnimated:YES];
                                 } failure:^(NSError *error) {
                                     [self showHudMessage:@"连接服务器失败!"];
                                 }];
}
- (void)myTimerAction
{
    
    if (_time != 0) {
        _time --;
        [self.header timerCutWithTime:_time];
        if (_time == 0) {
            UIViewController *vc = self.navigationController.viewControllers[2];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }else{
        [_timer invalidate];
    }
}

#pragma mark -- 按钮点击
- (void)payBtnAction:(UIButton *)sender {
    
    NSLog(@"立即支付");
   
    [self loadBuyTicket];
    
}

/**
 支付
 */
- (void)goPay {
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
    
    NSString *seatStr;
    NSMutableArray *seats = [NSMutableArray array];
    for (ZFSeatButton *seatButton in self.selectedSeats) {
        ZFSeatModel *seatModel = seatButton.seatmodel;
        NSInteger row = [seatModel.rowValue integerValue];
        NSInteger col = [seatModel.columnValue integerValue];
        [seats addObject:[NSString stringWithFormat:@"%zd排%zd座",row,col]];
    }
    seatStr = [seats componentsJoinedByString:@" "];
    
    payment.seats = seatStr;
    
    
    payment.goods = [self pictureArrayToJSON:self.souvenirStr];
    payment.isTicket = YES;
    [payment setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:payment animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 获取选中的套餐


#pragma mark -- 计算 选中 商品 总价
- (CGFloat)totalMoney {
    CGFloat money = 0;
    
    for (int i = 0; i<self.goodsList.count; i++) {
        Goods *good = self.goodsList[i];
        money += good.selectedNumber * good.price;
    }
    return money;
    
}

- (void)setTotalMoney {
    
    NSString *moneyStr =self.film[@"market_price"];
    CGFloat money = [self totalMoney] + [moneyStr  floatValue] * self.selectedSeats.count - self.couponPrice > 0?  [self totalMoney] + [self.film[@"market_price"]  floatValue] * self.selectedSeats.count - self.couponPrice : 0;
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"还需支付 %.2f元",money];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.totalMoneyLabel.text];
    NSRange strRange = [self.totalMoneyLabel.text rangeOfString:@"还需支付 "];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
    self.totalMoneyLabel.attributedText = attributeStr;
}


#pragma mark --PackageTableViewCellDelegate

- (void)gotoBuyPackageEvent{
    
}

- (void)gotoPackageAmountChangeEvent:(NSInteger)amount indexPath:(NSIndexPath *)index{
    NSLog(@"%zd",amount);
    Goods *good = self.goodsList[index.row];
    good.selectedNumber = amount;
    
    CGFloat money = [self totalMoney] + [self.film[@"market_price"]  floatValue] * self.selectedSeats.count - self.couponPrice > 0? [self totalMoney] + [self.film[@"market_price"]  floatValue] * self.selectedSeats.count - self.couponPrice : 0;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"还需支付 %.2f元",money];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.totalMoneyLabel.text];
    NSRange strRange = [self.totalMoneyLabel.text rangeOfString:@"还需支付 "];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
    self.totalMoneyLabel.attributedText = attributeStr;

}

- (void)gotoPackageAmountUpperLimitEvent{
    
}


@end
