//
//  ExchangeViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/9.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ExchangeViewCtl.h"
#import "SDCycleScrollView.h"
#import "ExchangeTicketViewCtl.h"
#import "RefundView.h"
@interface ExchangeViewCtl ()<SDCycleScrollViewDelegate,RefundViewDelegate>
{
    SDCycleScrollView *_adView;
    UILabel *_foodsTypeLb;
    UILabel *_foodsNameLb;
    UILabel *_integralLb;
    UILabel *_originalLb;
    UILabel *_cinemaNameLb;
    UILabel *_timeLb;
    UILabel *_descriptionLb;
    UIButton *_exchangeBtn;
    MBProgressHUD *_HUD;
    MBProgressHUD *_exchangeHUD;
}
@property(nonatomic,strong) NSMutableArray *sliders;  //!<< 轮播图
@property(nonatomic,strong) NSString *cinemaName;  //!<< 影院名
@property(nonatomic,strong) NSDictionary *shopDict;  //!<< 详情

@end

@implementation ExchangeViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"积分商城";
    
    UIScrollView *scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -63) target:self];
    [self.view addSubview:scrollView];
    
//    UIView *headView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 162) backgroundColor:Color(239, 239, 239, 1.0)];
//    [scrollView addSubview:headView];
    // 轮播图
    _adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    //cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    _adView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //cycleScrollView2.titlesGroup = titles;
    _adView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _adView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//    [headView addSubview:_adView];
    
    UIView *goodsView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 63) backgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:goodsView];
    
    NSString *typeName;
    NSString *name;
    if (self.shop.shop_type == 1) {
        typeName = @"电影票";
        name = self.shop.name;
    }else if (self.shop.shop_type == 2){
        typeName = @"观影套餐";
        name = self.shop.detail;
    }else{
        typeName = @"纪念品";
        name = self.shop.detail;
    }
    CGSize typeSize = [typeName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    _foodsTypeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 8, typeSize.width, 18) text:typeName font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [goodsView addSubview:_foodsTypeLb];
    
    _foodsNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +typeSize.width +13, 8, 200, 18) text:name font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [goodsView addSubview:_foodsNameLb];
    
    NSString *integral = [NSString stringWithFormat:@"%zd积分",self.shop.score];
    CGSize integralPreSize = [[NSString stringWithFormat:@"%zd",self.shop.score] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    CGSize integrallatSize = [@"积分" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _integralLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 8 +18 +10, integralPreSize.width +integrallatSize.width, 18) text:integral font:[UIFont systemFontOfSize:20] textColor:Color(0, 133, 229, 1.0) alignment:NSTextAlignmentLeft];
    [goodsView addSubview:_integralLb];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_integralLb.text];
    NSRange range = [_integralLb.text rangeOfString:@"积分"];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:Color(49, 160, 233, 1.0)} range:range];
    _integralLb.attributedText = str;
    
    _originalLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +_integralLb.frame.size.width +13, 8 +18 +16, 100, 12) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(146, 146, 146, 1.0) alignment:NSTextAlignmentLeft];
    [goodsView addSubview:_originalLb];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:_originalLb.text];
    [str1 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, _originalLb.text.length)];
    _originalLb.attributedText = str1;
    
    NSArray *titles = @[@"影院：",@"活动时间：",@"详情说明："];
    //    NSArray *contents = @[@"中影UL城市影院（乐尚店）",@"2016-0812 至 2016-08-30",@"•  本电影票在活动时间内可兑换本影院任意一张电影票。\n•  兑换的电影票概不接受“退票”“换票”。\n•  本商品仅限在本影院使用。"];
    for (int i = 0; i < 3; i ++) {
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(12, 63 + i *45, ScreenWidth -24, 1) backgroundColor:Color(236, 236, 236, 1.0)];
        [scrollView addSubview:line];
        
        CGSize titleSize = [titles[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        UILabel *titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 63 + i *45 +13, titleSize.width, 18) text:titles[i] font:[UIFont systemFontOfSize:15] textColor:Color(253, 147, 45, 1.0) alignment:NSTextAlignmentLeft];
        [scrollView addSubview:titleLb];
        
        if (i != 2) {
            UILabel *contentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +titleSize.width, 63 + i *45 +13, 250, 18) text:@"" font:[UIFont systemFontOfSize:15] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentLeft];
            [scrollView addSubview:contentLb];
            if (i == 0) {
                _cinemaNameLb = contentLb;
            }else{
                _timeLb = contentLb;
            }
        }else{
            CGSize descriptionSize = [FanShuToolClass createString:@"" font:[UIFont systemFontOfSize:14] lineSpacing:10 maxSize:CGSizeMake(ScreenWidth -24, ScreenHeight)];
            UILabel *description = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 63 + i *45 +13 +18 +12, ScreenWidth -24, descriptionSize.height) text:@"" font:[UIFont systemFontOfSize:14] textColor:Color(67, 67, 67, 1.0) alignment:NSTextAlignmentLeft];
            description.numberOfLines = 0;
            _descriptionLb = description;
            [scrollView addSubview:description];
            _descriptionLb.attributedText = [FanShuToolClass getAttributeStringWithContent:@"" withLineSpaceing:10];
        }
    }
    
    _exchangeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12, ScreenHeight -64 -90, ScreenWidth -24, 52) title:@"兑换" titleColor:[UIColor whiteColor] cornerRadius:3.0 font:[UIFont systemFontOfSize:16] backgroundColor:Color(252, 186, 0, 1.0) target:self action:@selector(exchangeBtnDidClicked:) tag:100];
    [scrollView addSubview:_exchangeBtn];
    
    [self loadShopGoodsDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableArray *)sliders
{
    if (_sliders == nil) {
        _sliders = [NSMutableArray array];
    }
    return _sliders;
}

#pragma mark - View Handle
- (void)exchangeBtnDidClicked:(UIButton *)btn
{
    if ([self.shopDict[@"shop_type"] intValue] == 1) { //电影票
        
        ExchangeTicketViewCtl *exchangeTicket = [[ExchangeTicketViewCtl alloc] init];
        exchangeTicket.id = self.shop.id;
        exchangeTicket.name = self.cinemaName;
        [exchangeTicket setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:exchangeTicket animated:YES];
        
    }else if ([self.shopDict[@"shop_type"] intValue] == 2){ //观影套餐
        NSString *message = @"观影套餐兑换成功，相应积分将自动扣除，观影套餐请在“我的订单”里面查看。";
        [self exchangeGoodsWithMessage:message];
    }else{ //纪念品
        NSString *message = @"纪念品兑换成功，相应积分将自动扣除，观影套餐请在“我的订单”里面查看。";
        [self exchangeGoodsWithMessage:message];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark - RefundViewDelegate
- (void)gotoRefundViewEvents:(NSInteger)tag
{
    //发送通知刷新
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeNotification" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - help Methods
/**
 兑换观影套餐/纪念品
 */
- (void)exchangeGoodsWithMessage:(NSString *)message
{
    _exchangeHUD = [FanShuToolClass createMBProgressHUDWithText:@"兑换中..." target:self];
    [self.view addSubview:_exchangeHUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserExchangeGoodsURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"id"] = self.shop.id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue]== 0) {
            [_exchangeHUD hideAnimated:YES];
            NSDictionary *content = dataBack[@"content"];
            if ([content[@"is_ok"] boolValue]) {
                
                [self showPopWindowWithMessage:message];
                
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
            [_exchangeHUD hideAnimated:YES];
        }
    } failure:^(NSError *error) {
        [_exchangeHUD hideAnimated:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

/**
 兑换成功弹窗
 
 @param message 弹窗信息
 */
- (void)showPopWindowWithMessage:(NSString *)message
{
    NSString *content = message;
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


/**
 积分商品详情
 */
- (void)loadShopGoodsDetail
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserShopGoodsDetailURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"id"] = self.shop.id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getShopGoodsDetail >>>>>>>>>>>>>> %@",dataBack);
        NSDictionary *content = dataBack[@"content"];
        if ([dataBack[@"code"] intValue] == 0) {
            self.sliders = content[@"sliders"];
            self.cinemaName = content[@"cinema_name"];
            self.shopDict = content[@"shop"];
            for (int i = 0; i < self.sliders.count; i ++) {
                [self.sliders replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,self.sliders[i]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self configUI];
            });
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)configUI
{
    _adView.imageURLStringsGroup = self.sliders;
    NSString *typeName;
    NSString *name;
    if ([self.shopDict[@"shop_type"] intValue] == 1) {
        typeName = @"电影票";
        name = self.shopDict[@"name"];
    }else if ([self.shopDict[@"shop_type"] intValue] == 2){
        typeName = @"观影套餐";
        name = self.shopDict[@"detail"];
    }else{
        typeName = @"纪念品";
        name = self.shopDict[@"detail"];
    }
    CGSize typeSize = [typeName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    _foodsTypeLb.frame = CGRectMake(12, 8, typeSize.width, 18);
    _foodsTypeLb.text = typeName;
    
    _foodsNameLb.frame = CGRectMake(12 +typeSize.width +13, 8, 200, 18);
    _foodsNameLb.text = self.shopDict[@"name"];
    
    CGSize integralPreSize = [[NSString stringWithFormat:@"%@",self.shopDict[@"score"]] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    CGSize integrallatSize = [@"积分" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _integralLb.frame = CGRectMake(12, 8 +18 +10, integralPreSize.width +integrallatSize.width, 18);
    _integralLb.text = [NSString stringWithFormat:@"%@积分",self.shopDict[@"score"]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_integralLb.text];
    NSRange range = [_integralLb.text rangeOfString:@"积分"];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:Color(49, 160, 233, 1.0)} range:range];
    _integralLb.attributedText = str;
    
    
    _originalLb.frame = CGRectMake(12 +_integralLb.frame.size.width +13, 8 +18 +16, 100, 12);
    _originalLb.text = [NSString stringWithFormat:@"￥%d",[self.shopDict[@"goods_price"] intValue]];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:_originalLb.text];
    [str1 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, _originalLb.text.length)];
    _originalLb.attributedText = str1;
    
    _cinemaNameLb.text = self.cinemaName;
    _timeLb.text = [NSString stringWithFormat:@"%@ 至 %@",[self.shopDict[@"start_time"] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"],[self.shopDict[@"end_time"] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"]];
    CGSize descriptionSize = [FanShuToolClass createString:[NSString stringWithFormat:@"%@",self.shopDict[@"shop_detail"]] font:[UIFont systemFontOfSize:14] lineSpacing:10 maxSize:CGSizeMake(ScreenWidth -24, ScreenHeight)];
    _descriptionLb.frame = CGRectMake(12, 63 + 2 *45 +13 +18 +12, ScreenWidth -24, descriptionSize.height);
    _descriptionLb.attributedText = [FanShuToolClass getAttributeStringWithContent:[NSString stringWithFormat:@"%@",self.shopDict[@"shop_detail"]] withLineSpaceing:10];
}

@end
