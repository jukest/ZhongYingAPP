//
//  ConfirmPackageOrderViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ConfirmPackageOrderViewCtl.h"
#import "CouponViewCtl.h"
#import "PaymentViewCtl.h"
#import "Coupon.h"

@interface ConfirmPackageOrderViewCtl ()<UITextFieldDelegate>
{
    MBProgressHUD *_LoadCouponHUD;
    Coupon *_coupon;
}
@property(nonatomic,assign) float couponPrice; //!<< 优惠价格
@property(nonatomic,strong) NSArray *selectCou;
@end

@implementation ConfirmPackageOrderViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color(245, 245, 245, 1.0);
    self.navigationItem.title = @"确认订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerLJWKeyboardHandler];
    self.couponPrice = 0;
    UIScrollView *scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -63) target:self];
    [self.view addSubview:scrollView];
    
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 270 +30) backgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:view];
    for (int i = 0; i < 5; i ++) {
        UIView *line;
        if (i < 1) {
            line = [FanShuToolClass createViewWithFrame:CGRectMake(12, 45 * (i +1), ScreenWidth -24, 1) backgroundColor:Color(230, 230, 230, 1.0)];
        }else{
            line = [FanShuToolClass createViewWithFrame:CGRectMake(12, 45 * (i +1) +30, ScreenWidth -24, 1) backgroundColor:Color(230, 230, 230, 1.0)];
        }
        [view addSubview:line];
    }
    
    NSArray *arr = @[self.cinemaMsg.title,[NSString stringWithFormat:@"%@\n%@",self.goods.name,self.goods.detail],@"单价",@"数量",@"优惠券",@"总价"];
    for (int i = 0; i < 6; i ++) {
        UILabel *lb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 14 + i * 45, 100, 45 -28) text:arr[i] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        if (i == 0 || i == 1) {
            lb.frame = CGRectMake(12, 14 + i * 45, ScreenWidth -24, 45 -28);
            if (i == 0) {
                self.nameLb = lb;
            }else{
                lb.frame = CGRectMake(12, 14 + i * 45, ScreenWidth -24, 45 +30 -28);
                lb.numberOfLines = 0;
                //lb.attributedText = [FanShuToolClass getAttributeStringWithContent:arr[i] withLineSpaceing:5];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:arr[i]];
                NSRange range = NSMakeRange([self.goods.name length] +1, [self.goods.detail length]);
                [str addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:range];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                [style setLineSpacing:5];
                [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, lb.text.length)];
                lb.attributedText = str;
                
                self.packageLb = lb;
            }
        }else{
            lb.frame = CGRectMake(12, 14 + i  * 45 +30, ScreenWidth -24, 45 -28);
        }
        [view addSubview:lb];
    }
    
    self.unitPriceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -12 -80, 14 + 90 +30, 80, 45 -28) text:[NSString stringWithFormat:@"%.2f 元",self.goods.price] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    [dict setObject:Color(80, 80, 80, 1.0) forKey:NSForegroundColorAttributeName];
    self.unitPriceLb.attributedText = [self addAttributes:dict withString:self.unitPriceLb.text];
    [view addSubview:self.unitPriceLb];
    
    self.amountFld = [FanShuToolClass createTextFieldWithFrame:CGRectMake(ScreenWidth -12 -145 +30 +9, 135 + 8 +30, 66, 30) textColor:Color(59, 160, 250, 1.0) font:[UIFont systemFontOfSize:17] target:self];
    self.amountFld.keyboardType = UIKeyboardTypeNumberPad;
    self.amountFld.text = @"1";
    self.amountFld.clearButtonMode = UITextFieldViewModeNever;
    self.amountFld.layer.borderWidth = 0.5;
    self.amountFld.layer.borderColor = Color(59, 160, 250, 1.0).CGColor;
    self.amountFld.layer.cornerRadius = 3.0;
    self.amountFld.layer.masksToBounds = YES;
    self.amountFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.amountFld.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.amountFld.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.amountFld];
    
    self.minusBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -12 -145, 135 + 8 +30, 30, 30) title:@"-" titleColor:[UIColor whiteColor] target:self action:@selector(ConfirmOrderViewEvents:) tag:AmountMinusEvent];
    self.minusBtn.backgroundColor = Color(59, 160, 250, 1.0);
    self.minusBtn.layer.cornerRadius = 3.0;
    self.minusBtn.layer.masksToBounds = YES;
    [view addSubview:self.minusBtn];
    
    self.addBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -12 -145 +30 +9 +66 +9, 135 + 8 +30, 30, 30) title:@"+" titleColor:[UIColor whiteColor] target:self action:@selector(ConfirmOrderViewEvents:) tag:AmountAddEvent];
    self.addBtn.backgroundColor = Color(59, 160, 250, 1.0);
    self.addBtn.layer.cornerRadius = 3.0;
    self.addBtn.layer.masksToBounds = YES;
    [view addSubview:self.addBtn];
    
    self.couponLb = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -12 -100, 180 +30, 100, 45) title:@"减0元" titleColor:Color(247, 86, 109, 1.0) target:self action:@selector(ConfirmOrderViewEvents:) tag:CouponEvent];
    self.couponLb.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.couponLb setImage:[UIImage imageNamed:@"cinema_back"] forState:UIControlStateNormal];
    [self leftTitleRightImage];
    [view addSubview:self.couponLb];
    
    UIView *backView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 180 +30, ScreenWidth, 45) backgroundColor:[UIColor clearColor]];
    [view addSubview:backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCoupon:)];
    [backView addGestureRecognizer:tap];
    
    self.totalPricrLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -12 -50, 14 + 225 +30, 50, 45 -28) text:[NSString stringWithFormat:@"%.2f 元",self.goods.price] font:[UIFont systemFontOfSize:17] textColor:Color(199, 0, 0, 1.0) alignment:NSTextAlignmentRight];
    [self addAttributedText];
    [view addSubview:self.totalPricrLb];
    
    self.tipsLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 270 +15 +30, ScreenWidth, 15) text:@"注：本商品可退票，退还金额不包含优惠券。" font:[UIFont systemFontOfSize:14] textColor:Color(84, 84, 84, 1.0) alignment:NSTextAlignmentLeft];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:self.tipsLb.text];
    NSRange range = [self.tipsLb.text rangeOfString:@"注："];
    [str2 addAttribute:NSForegroundColorAttributeName value:Color(246, 0, 68, 1.0) range:range];
    self.tipsLb.attributedText = str2;
    [scrollView addSubview:self.tipsLb];
    
    self.gotoPayBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, ScreenHeight -97 -64 -43, ScreenWidth -30, 43) title:@"确认支付" titleColor:[UIColor whiteColor] target:self action:@selector(ConfirmOrderViewEvents:) tag:GotoPayEvent];
    self.gotoPayBtn.backgroundColor = Color(252, 186, 0, 1.0);
    self.gotoPayBtn.layer.cornerRadius = 5.0;
    self.gotoPayBtn.layer.masksToBounds = YES;
    self.gotoPayBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [scrollView addSubview:self.gotoPayBtn];
    
    [self loadGoodsCoupons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods
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
                self.couponPrice = [_coupon.price floatValue];
                self.selectCou = @[_coupon.id];
            }
            [self.couponLb setTitle:[NSString stringWithFormat:@"减%.2f元",self.couponPrice] forState:UIControlStateNormal];
            NSString *price = [NSString stringWithFormat:@"%.2f 元",(self.goods.price * [self.amountFld.text floatValue] -_couponPrice) > 0 ? self.goods.price * [self.amountFld.text floatValue] -_couponPrice : 0];
            CGSize priceSize = [price sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
            self.totalPricrLb.frame = CGRectMake(ScreenWidth -12 -priceSize.width, 14 + 225 +30, priceSize.width, 45 -28);
            self.totalPricrLb.text = price;
            [self addAttributedText];
            
            [self leftTitleRightImage];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_LoadCouponHUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [_LoadCouponHUD hideAnimated:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)addAttributedText
{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    [dict1 setObject:Color(246, 0, 68, 1.0) forKey:NSForegroundColorAttributeName];
    self.totalPricrLb.attributedText = [self addAttributes:dict1 withString:self.totalPricrLb.text];
}

- (NSMutableAttributedString *)addAttributes:(NSDictionary<NSString *, id> *)attrs withString:(NSString *)string
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:@"元"];
    [str addAttributes:attrs range:range];
    return str;
}

- (void)leftTitleRightImage
{
    CGFloat w =(self.couponLb.frame.size.width -(self.couponLb.imageView.image.size.width + self.couponLb.titleLabel.bounds.size.width)) / 2;
    [self.couponLb setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.couponLb.imageView.image.size.width +w -self.couponLb.imageView.image.size.width -3, 0, self.couponLb.imageView.image.size.width -w +self.couponLb.imageView.image.size.width +3)];
    [self.couponLb setImageEdgeInsets:UIEdgeInsetsMake(0, self.couponLb.titleLabel.bounds.size.width +w -self.couponLb.imageView.image.size.width, 0, -self.couponLb.titleLabel.bounds.size.width -w +self.couponLb.imageView.image.size.width)];
}

#pragma mark - View Handle
- (void)ConfirmOrderViewEvents:(UIButton *)btn
{
    if (btn.tag == AmountMinusEvent || btn.tag == AmountAddEvent) {
        if (btn.tag == AmountMinusEvent) {  //减数量
            if (![self.amountFld.text isEqualToString:@"0"]) {
                self.amountFld.text = [NSString stringWithFormat:@"%zd",[self.amountFld.text integerValue] -1];
                if ([self.amountFld.text isEqualToString:@"0"]) {
                    self.gotoPayBtn.backgroundColor = Color(204, 204, 204, 1.0);;
                    self.gotoPayBtn.enabled = NO;
                }
            }
        }else if (btn.tag == AmountAddEvent){  // 加数量
            if (![self.amountFld.text isEqualToString:@"9"]) {
                self.amountFld.text = [NSString stringWithFormat:@"%zd",[self.amountFld.text integerValue] +1];
                self.gotoPayBtn.backgroundColor = Color(252, 186, 0, 1.0);
                self.gotoPayBtn.enabled = YES;
            }else{
                [self showHudMessage:@"该套餐最多能选择9份"];
            }
        }
        NSString *price = [NSString stringWithFormat:@"%.2f 元",(self.goods.price * [self.amountFld.text floatValue] -_couponPrice) > 0 ? self.goods.price * [self.amountFld.text floatValue] -_couponPrice : 0];
        CGSize priceSize = [price sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        self.totalPricrLb.frame = CGRectMake(ScreenWidth -12 -priceSize.width, 14 + 225 +30, priceSize.width, 45 -28);
        self.totalPricrLb.text = price;
        [self addAttributedText];
        
    }else if (btn.tag == CouponEvent){  // 优惠券
        
        [self jumpToCouponViewControler];
        
    }else if (btn.tag == GotoPayEvent){ //确认支付
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"id"] = @(self.goods.id);
        dict[@"number"] = @([_amountFld.text integerValue]);
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
}

- (NSString *)pictureArrayToJSON:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}

- (void)gotoCoupon:(UIGestureRecognizer *)tap
{
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
    __weak ConfirmPackageOrderViewCtl *weak = self;
    coupon.block = ^void(NSArray *coupons){
        self.couponPrice = 0;
        NSMutableArray *couponArr = [NSMutableArray array];
        for (Coupon *c in coupons) {
            self.couponPrice = self.couponPrice +[c.price floatValue];
            [couponArr addObject:c.id];
        }
        [weak.couponLb setTitle:[NSString stringWithFormat:@"减%.2f元",self.couponPrice] forState:UIControlStateNormal];
        NSString *price = [NSString stringWithFormat:@"%.2f",(self.goods.price * [self.amountFld.text floatValue] -_couponPrice) > 0 ? self.goods.price * [self.amountFld.text floatValue] -_couponPrice : 0];
        CGSize priceSize = [price sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        self.totalPricrLb.frame = CGRectMake(ScreenWidth -12 -priceSize.width, 14 + 225 +30, priceSize.width, 45 -28);
        self.totalPricrLb.text = price;
        [self addAttributedText];
        weak.selectCou = couponArr;
    };
    [coupon setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:coupon animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}


@end
