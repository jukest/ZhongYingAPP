//
//  ZYMallConfirmViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMallConfirmViewController.h"
#import "Goods.h"
#import "ZYMallCell.h"
#import "Coupon.h"
#import "CouponViewCtl.h"
#import "PaymentViewCtl.h"


@interface ZYMallConfirmViewController ()<UITableViewDelegate,UITableViewDataSource,ZYMallCellDelegate>
{
    MBProgressHUD *_LoadCouponHUD;
    Coupon *_coupon;
}
/** tableView */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *sectionFooterView;

@property (nonatomic, strong) UIButton *couponBtn;

@property (nonatomic, strong) UILabel *totalPricrLb;

@property(nonatomic,strong) UIButton *gotoPayBtn;

@property(nonatomic,assign) NSInteger couponPrice; //!<< 优惠价格
@property(nonatomic,strong) NSArray *selectCou;

@end

static NSString *reuseIdentifier = @"mallCell";

@implementation ZYMallConfirmViewController

- (void)dealloc {
    NSLog(@"被释放了");
    self.callBack();
    self.callBack = nil;

}

- (void)setGoodsList:(NSMutableArray *)goodsList {
    _goodsList = goodsList;
    
    self.tableView.tableFooterView = self.sectionFooterView;

    self.totalPricrLb.text = [NSString stringWithFormat:@"%.2f",[self totalMoney]];

    
    
}


#pragma mark - 懒加载

- (UIView *)sectionFooterView {
    if (!_sectionFooterView) {
        _sectionFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ZYMallConfirmViewControllerTableViewSectionFooterVierHeight)];
        _sectionFooterView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 2)];
        lineView1.backgroundColor = Color(230, 230, 230, 1);
        [_sectionFooterView addSubview:lineView1];
        
        UILabel *label = [FanShuToolClass createLabelWithFrame:CGRectMake(10, 2, 100, ZYMallConfirmViewControllerTableViewSectionFooterVierLabelHeight) text:@"优惠券" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [_sectionFooterView addSubview:label];
        
        self.couponBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 2,ScreenWidth-10, ZYMallConfirmViewControllerTableViewSectionFooterVierLabelHeight) title:@"减0元" titleColor:Color(247, 86, 109, 1.0) target:self action:@selector(couponAction:) tag:1];
        [_sectionFooterView addSubview:self.couponBtn];
        [self.couponBtn setImage:[UIImage imageNamed:@"cinema_back"] forState:UIControlStateNormal];
        self.couponBtn.backgroundColor = [UIColor clearColor];
        self.couponBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.couponBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        self.couponBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -45);
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, ZYMallConfirmViewControllerTableViewSectionFooterVierLabelHeight + 4, ScreenWidth, 2)];
        lineView.backgroundColor = Color(230, 230, 230, 1);
        [_sectionFooterView addSubview:lineView];
        
        CGFloat y = CGRectGetMaxY(lineView.frame) + 6;
        UILabel *totalLabel =[FanShuToolClass createLabelWithFrame:CGRectMake(10, y, 100, ZYMallConfirmViewControllerTableViewSectionFooterVierLabelHeight) text:@"总价" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [_sectionFooterView addSubview:totalLabel];
        
        self.totalPricrLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth - 110, y, 100, ZYMallConfirmViewControllerTableViewSectionFooterVierLabelHeight) text:[NSString stringWithFormat:@"%zd 元",0] font:[UIFont systemFontOfSize:17] textColor:Color(199, 0, 0, 1.0) alignment:NSTextAlignmentRight];
        [_sectionFooterView addSubview:self.totalPricrLb];
        
        y = CGRectGetMaxY(self.totalPricrLb.frame);
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ZYMallConfirmViewControllerTableViewSectionFooterVierHeight - y)];
        bottomView.backgroundColor = Color(230, 230, 230, 1);
        [_sectionFooterView addSubview:bottomView];
        
        UILabel *tipsLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 5, ScreenWidth, 15) text:@"注：本商品可退票，退还金额不包含优惠券。" font:[UIFont systemFontOfSize:14] textColor:Color(84, 84, 84, 1.0) alignment:NSTextAlignmentLeft];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:tipsLb.text];
        NSRange range = [tipsLb.text rangeOfString:@"注："];
        [str2 addAttribute:NSForegroundColorAttributeName value:Color(246, 0, 68, 1.0) range:range];
        tipsLb.attributedText = str2;
        [bottomView addSubview:tipsLb];
        
        self.gotoPayBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, bottomView.height - 35, ScreenWidth -30, 35) title:@"确认支付" titleColor:[UIColor whiteColor] target:self action:@selector(sureBtnAction:) tag:2];
        self.gotoPayBtn.backgroundColor = Color(252, 186, 0, 1.0);
        self.gotoPayBtn.layer.cornerRadius = 5.0;
        self.gotoPayBtn.layer.masksToBounds = YES;
        self.gotoPayBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [bottomView addSubview:self.gotoPayBtn];
        
        
    }
    return _sectionFooterView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[ZYMallCell class] forCellReuseIdentifier:reuseIdentifier];
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"确认订单";
    self.view.backgroundColor = Color(230, 230, 230, 1);
    
    [self loadGoodsCoupons];
}




#pragma mark - UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMallCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    Goods *good = self.goodsList[indexPath.row];
    cell.delegate = self;
    cell.good = good;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZYMallViewControllerCellHeight;
}


#pragma mark -- ZYMallCellDelegate

- (void)mallCell:(UITableViewCell *)cell plusBtnDidClick:(UIButton *)button withNumberOfGood:(NSInteger)number {
//    NSInteger index = [self.tableView indexPathForCell:cell].row;
//    Goods *good = self.goodsList[index];
//    NSLog(@"买%ld",(long)good.selectedNumber);
    
    
    self.totalPricrLb.text = [NSString stringWithFormat:@"%.2f",[self totalMoney]];

    
}

- (void)mallCell:(UITableViewCell *)cell subtractBtnDidClick:(UIButton *)button withNumberOfGood:(NSInteger)number {
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    Goods *good = self.goodsList[index];
    
    if (good.selectedNumber == 0) {
        [self.goodsList removeObject:good];
        [self.tableView reloadData];
    }
    
    
    if (self.goodsList.count == 0) {
        self.tableView.tableFooterView = nil;
        self.tableView = nil;
        [self showHudMessage:@"请选择商品"];
        
    }
    
//    if (self.goodsList.count == 1) {
//        
//        Goods *good = self.goodsList[index];
//        if (good.selectedNumber == 1) {
//            
//            good.selectedNumber++;
//            
//        } else {
//
//        }
//        
//        
//    }
    
    self.totalPricrLb.text = [NSString stringWithFormat:@"%.2f",[self totalMoney]];

    
}

#pragma mark -- 计算总价
- (CGFloat)totalMoney {
    CGFloat money = 0;
    
    for (int i = 0; i<self.goodsList.count; i++) {
        Goods *good = self.goodsList[i];
        money += good.selectedNumber * good.price;
    }
    return money;
    
}

#pragma mark -- 选择优惠券
- (void)couponAction:(UIButton *)sender {
    NSLog(@"选择优惠券");
    [self jumpToCouponViewControler];
}

- (void)jumpToCouponViewControler
{
    CouponViewCtl *coupon = [[CouponViewCtl alloc] init];
    coupon.hasSnack = YES;
    coupon.hasTicket = NO;
    if (_coupon.id == nil) {
        coupon.coupon_ids = @[];
    }else{
        coupon.coupon_ids = @[_coupon.id];
    }
    __weak typeof(self) weak = self;
    coupon.block = ^void(NSArray *coupons){
        self.couponPrice = 0;
        NSMutableArray *couponArr = [NSMutableArray array];
        for (Coupon *c in coupons) {
            self.couponPrice = self.couponPrice +[c.price integerValue];
            [couponArr addObject:c.id];
        }
        [weak.couponBtn setTitle:[NSString stringWithFormat:@"减%zd元",self.couponPrice] forState:UIControlStateNormal];
        NSString *price = [NSString stringWithFormat:@"%.2f ",([self totalMoney] -_couponPrice) > 0 ? [self totalMoney] -_couponPrice : 0];
        weak.totalPricrLb.text = price;
        weak.selectCou = couponArr;
    };
    [coupon setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:coupon animated:YES];
}


#pragma mark -- 确认支付
- (void)sureBtnAction:(UIButton *)sender {
    NSLog(@"确认支付");
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.goodsList.count; i++) {
        Goods *good = self.goodsList[i];
        
        dict[@"id"] = @(good.id);
        dict[@"number"] = @(good.selectedNumber);
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *goods_info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    PaymentViewCtl *payment = [[PaymentViewCtl alloc] init];
    if (self.selectCou.count != 0) {
        payment.coupon_id = self.selectCou[0];
    }else{
        payment.coupon_id = nil;
    }
    payment.goods = [self pictureArrayToJSON:goods_info];
    payment.isTicket = NO;
    [payment setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:payment animated:YES];
}

- (NSString *)pictureArrayToJSON:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}



#pragma mark - loadGoodsCoupons
- (void)loadGoodsCoupons
{
    _LoadCouponHUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_LoadCouponHUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserGoodsCouponsURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            _coupon = [[Coupon alloc] init];
            if ([content[@"coupon"] count] != 0) {
                _coupon.id = [NSString stringWithFormat:@"%@",content[@"coupon"][0][@"id"]];
                _coupon.price = [NSString stringWithFormat:@"%@",content[@"coupon"][0][@"price"]];
                self.couponPrice = [_coupon.price integerValue];
                self.selectCou = @[_coupon.id];
            }
            [self.couponBtn setTitle:[NSString stringWithFormat:@"减%zd元",self.couponPrice] forState:UIControlStateNormal];
            NSString *price = [NSString stringWithFormat:@"%.2f ",([self totalMoney] -_couponPrice) > 0 ? [self totalMoney] -_couponPrice : 0];
            self.totalPricrLb.text = price;
            
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_LoadCouponHUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [_LoadCouponHUD hideAnimated:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

@end
