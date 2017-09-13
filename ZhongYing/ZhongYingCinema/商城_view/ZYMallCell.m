//
//  ZYMallCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMallCell.h"
#import "UIImageView+WebCache.h"

@interface ZYMallCell()

/**
 美食图片
 */
@property (nonatomic, strong) UIImageView *mallImageView;

/**
 美食名
 */
@property (nonatomic, strong) UILabel *mallNameLabel;


/**
 美食描述
 */
@property (nonatomic, strong) UILabel *mallDetailLabel;



/**
 美食价格
 */
@property (nonatomic, strong) UILabel *mallPriceLabel;


/**
 数量 -
 */
@property (nonatomic, strong) UIButton *numberSubtractBtn;


/**
 显示数量的label
 */
@property (nonatomic, strong) UILabel *numberLabel;


/**
 数量 +
 */
@property (nonatomic, strong) UIButton *numberPlusBtn;


@end


@implementation ZYMallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
         return self;
}


- (void)setup {
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(2*ZYMallViewControllerMarge, 2*ZYMallViewControllerMarge, ScreenWidth - 4*ZYMallViewControllerMarge, ZYMallViewControllerCellHeight - 2 *ZYMallViewControllerMarge)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 10;
    backgroundView.layer.masksToBounds = YES;
    [self addSubview:backgroundView];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZYMallViewControllerCellImgViewWeight, ZYMallViewControllerCellImgViewHeight)];
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    imgView.backgroundColor = [UIColor redColor];
    self.mallImageView = imgView;
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapAction:)];
    [imgView addGestureRecognizer:tap];
    [backgroundView addSubview:imgView];
    
    CGFloat x = CGRectGetMaxX(imgView.frame) + ZYMallViewControllerMarge;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, ZYMallViewControllerMarge, ScreenWidth - x - ZYMallViewControllerMarge, ZYMallViewControllerCellMallNameHeight)];
    label.text = @"七夕情侣特惠套餐";
    label.font = [UIFont systemFontOfSize:14];
//    label.backgroundColor = [UIColor redColor];
    self.mallNameLabel = label;
    [backgroundView addSubview:label];
    
    CGFloat y = CGRectGetMaxY(label.frame) ;
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, ScreenWidth - x - 4*ZYMallViewControllerMarge - ZYMallViewControllerCellNumberLabelWidth - 2 * ZYMallViewControllerCellBtnWH, ZYMallViewControllerCellMallDetaLabelHeight)];
    detailLabel.text = @"七夕情侣特惠套餐";
    detailLabel.numberOfLines = 2;
//    detailLabel.backgroundColor = [UIColor redColor];
    detailLabel.font = [UIFont systemFontOfSize:12];
    

    detailLabel.textColor = [UIColor lightGrayColor];
    self.mallDetailLabel = detailLabel;
    [backgroundView addSubview:detailLabel];
    
    y = CGRectGetMaxY(self.mallDetailLabel.frame);
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 100, ZYMallViewControllerCellMallPriceHeight)];
    price.text = @"￥12.00";
    price.textColor = [UIColor redColor];
    self.mallPriceLabel = price;
    [backgroundView addSubview:self.mallPriceLabel];
    
    x = ScreenWidth - 4*ZYMallViewControllerMarge - ZYMallViewControllerCellBtnWH;
//    y = CGRectGetMaxY(self.mallDetailLabel.frame) + 5;
    y = (ZYMallViewControllerCellHeight - ZYMallViewControllerCellBtnWH) * 0.5;
    UIButton *numberPlusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numberPlusBtn.backgroundColor = Color(252, 186, 0, 1.0);
    numberPlusBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    numberPlusBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberPlusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [numberPlusBtn setTitle:@"+" forState:UIControlStateNormal];
    numberPlusBtn.frame = CGRectMake(x, y, ZYMallViewControllerCellBtnWH, ZYMallViewControllerCellBtnWH);
    [numberPlusBtn addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    numberPlusBtn.layer.cornerRadius = ZYMallViewControllerCellBtnWH * 0.5;

    [backgroundView addSubview:numberPlusBtn];
    self.numberPlusBtn = numberPlusBtn;
    
    x = ScreenWidth - 4*ZYMallViewControllerMarge - ZYMallViewControllerCellBtnWH - ZYMallViewControllerCellNumberLabelWidth;
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, ZYMallViewControllerCellNumberLabelWidth, ZYMallViewControllerCellNumberLabelHeight)];
//    numberLabel.backgroundColor = [UIColor redColor];
    numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.text = @"";
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    x = ScreenWidth - 4*ZYMallViewControllerMarge - ZYMallViewControllerCellBtnWH - ZYMallViewControllerCellNumberLabelWidth - ZYMallViewControllerCellBtnWH;
    UIButton *numberSubtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [numberSubtractBtn setImage:[UIImage imageNamed:@"mall_plusBtn"] forState:UIControlStateNormal];
    numberSubtractBtn.frame = CGRectMake(x, y, ZYMallViewControllerCellBtnWH, ZYMallViewControllerCellBtnWH);
    numberSubtractBtn.backgroundColor = Color(252, 186, 0, 1.0);
    numberSubtractBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [numberSubtractBtn setTitle:@"-" forState:UIControlStateNormal];
    numberSubtractBtn.layer.cornerRadius = ZYMallViewControllerCellBtnWH * 0.5;
    numberSubtractBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberSubtractBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backgroundView addSubview:numberSubtractBtn];
    [numberSubtractBtn addTarget:self action:@selector(subtractBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    self.numberSubtractBtn = numberSubtractBtn;
    self.numberSubtractBtn.hidden = YES;
    

    
}

- (void)setGood:(Goods *)good {
    _good = good;
    [self.mallImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,good.images]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.mallNameLabel.text = good.name;
    
    self.mallDetailLabel.text = good.detail;
    
    self.mallPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",good.price];
    
    if (good.selectedNumber != 0) {
        
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)good.selectedNumber];
        self.numberSubtractBtn.hidden = NO;
    }else {
        self.numberSubtractBtn.hidden = YES;
        self.numberLabel.text = @"";

    }
    
    
}


- (void)plusBtnAction:(UIButton *)sender {
    
    self.good.selectedNumber++;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.good.selectedNumber];

    if (self.good.selectedNumber != 0) {
        self.numberSubtractBtn.hidden = NO;
    } else {
        self.numberSubtractBtn.hidden = YES;

    }
    
    
    
    if (self.delegate != nil ) {
        if ([self.delegate respondsToSelector:@selector(mallCell:plusBtnDidClick:withNumberOfGood:)]) {
            [self.delegate mallCell:self plusBtnDidClick:sender withNumberOfGood:self.good.selectedNumber];
        }
    }
}

- (void)subtractBtnAction:(UIButton *)sender {
    
    
    self.good.selectedNumber--;
    if (self.good.selectedNumber == 0) {
        sender.hidden = YES;
        self.numberLabel.text = @"";
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.good.selectedNumber];
        sender.hidden = NO;

    }
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(mallCell:subtractBtnDidClick:withNumberOfGood:)]) {
            [self.delegate mallCell:self subtractBtnDidClick:sender withNumberOfGood:self.good.selectedNumber];
        } 
    }

    
}

- (void)imgViewTapAction:(UITapGestureRecognizer *)tapGesture {
    
    UIImageView *imgView = (UIImageView *)tapGesture.view;
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(mallCell:imageViewDidClick:)]) {
            [self.delegate mallCell:self imageViewDidClick:imgView];
        }
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

























