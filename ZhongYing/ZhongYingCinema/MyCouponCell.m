//
//  MyCouponCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyCouponCell.h"

@interface MyCouponCell ()
{
    UIView *_lineView;
}
@end
@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Color(239, 239, 239, 1.0);
        
        UIView *couponView = [FanShuToolClass createViewWithFrame:CGRectMake(12, 0, ScreenWidth -24, 135) backgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:couponView];
        
        NSArray *arr = @[@"coupon_background_green",@"coupon_background_blue",@"coupon_background_red"];
        self.backgroundImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 115, 135) image:[UIImage imageNamed:arr[arc4random() % 3]] tag:101];
        [couponView addSubview:self.backgroundImg];
        
        self.amountLb = [FanShuToolClass createLabelWithFrame:CGRectMake(18, 35, 130, 50) text:[NSString stringWithFormat:@"%zd元",(arc4random() % 50 +1)] font:[UIFont systemFontOfSize:35] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        self.amountLb.center = CGPointMake(57.5, 18 +35);
        [self.backgroundImg addSubview:self.amountLb];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.amountLb.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[self.amountLb.text rangeOfString:@"元"]];
        //[str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [self.amountLb.text length])];
        self.amountLb.attributedText = str;
        
        _lineView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, self.amountLb.text.length, 2) backgroundColor:[UIColor whiteColor]];
        _lineView.center = CGPointMake(57.5, 18 +35);
        [self.backgroundImg addSubview:_lineView];
        
        self.typeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 60, 10) text:@"代金券" font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        self.typeLb.center = CGPointMake(57.5, 18 +35 +25 +8);
        [self.backgroundImg addSubview:self.typeLb];
        
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(125, 8, 80, 20) text:@"优惠券" font:[UIFont systemFontOfSize:18] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentLeft];
        [couponView addSubview:self.titleLb];
        
        self.descriptionLb = [FanShuToolClass createLabelWithFrame:CGRectMake(125, 8 +20 +5, 150, 15) text:@"购买本店电影票可用" font:[UIFont systemFontOfSize:14] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
        [couponView addSubview:self.descriptionLb];
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(115, 105, ScreenWidth -24 -95, 1.0) backgroundColor:Color(248, 248, 248, 1.0)];
        [couponView addSubview:line];
        
        self.effectiveDateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -24 -6 -300, 105 +8, 300, 14) text:@"有效期至2016-11-04" font:[UIFont systemFontOfSize:14] textColor:Color(90, 90, 90, 1.0) alignment:NSTextAlignmentRight];
        [couponView addSubview:self.effectiveDateLb];
        
        self.useImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth -24 -68, 0, 68, 68) image:[UIImage imageNamed:@"coupon_not_use"] tag:102];
        [couponView addSubview:self.useImg];
        
        UIView *bottomView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 135, ScreenWidth -16, 15) backgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:bottomView];
    }
    return self;
}

- (void)configCellWithModel:(Coupon *)coupon
{
    NSString *price = [NSString stringWithFormat:@"%@元",coupon.price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[price rangeOfString:@"元"]];
    //[str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [price length])];
    self.amountLb.attributedText = str;
    
    CGSize amountSize = [coupon.price sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:40]}];
    CGSize size = [@"元" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    _lineView.frame = CGRectMake(0, 0, amountSize.width +size.width, 2);
    _lineView.center = CGPointMake(57.5, 18 +35 +20 +2);;
    
    if ([coupon.type isEqualToString:@"1"]) {
        self.descriptionLb.text = @"购买本店电影票可用";
    }else if ([coupon.type isEqualToString:@"2"]){
        self.descriptionLb.text = @"购买本店观影套餐可用";
    }
    if ([[coupon.price componentsSeparatedByString:@"."][0] intValue] <= 10) {
        self.backgroundImg.image = [UIImage imageNamed:@"coupon_background_green"];
    }else if ([[coupon.price componentsSeparatedByString:@"."][0] intValue] >10 && [[coupon.price componentsSeparatedByString:@"."][0] intValue] <= 20){
        self.backgroundImg.image = [UIImage imageNamed:@"coupon_background_blue"];
    }else{
        self.backgroundImg.image = [UIImage imageNamed:@"coupon_background_red"];
    }
    
    self.effectiveDateLb.text = [NSString stringWithFormat:@"有效期至%@",[coupon.end_time transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"]];
}

@end
