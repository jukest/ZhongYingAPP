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
    }
         return self;
}


- (void)setup {
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2 * ZYMallViewControllerMarge, ZYMallViewControllerMarge, ZYMallViewControllerCellImgViewWeight, ZYMallViewControllerCellImgViewHeight)];
    imgView.backgroundColor = [UIColor redColor];
    self.mallImageView = imgView;
    [self addSubview:imgView];
    
    CGFloat x = CGRectGetMaxX(imgView.frame) + ZYMallViewControllerMarge;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, ZYMallViewControllerMarge, ScreenWidth - x - ZYMallViewControllerMarge, ZYMallViewControllerCellMallNameHeight)];
    label.text = @"七夕情侣特惠套餐";
    label.font = [UIFont systemFontOfSize:14];
//    label.backgroundColor = [UIColor redColor];
    self.mallNameLabel = label;
    [self addSubview:label];
    
    CGFloat y = CGRectGetMaxY(label.frame) + ZYMallViewControllerMarge;
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, ScreenWidth - x - ZYMallViewControllerMarge, ZYMallViewControllerCellMallNameHeight)];
    detailLabel.text = @"七夕情侣特惠套餐";
    CGSize size = [detailLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth - x - ZYMallViewControllerMarge, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;

    if (size.height > 15.0) {
        size = CGSizeMake(ScreenWidth - x - ZYMallViewControllerMarge, 30);
    }
    
    detailLabel.numberOfLines = 2;
//    detailLabel.backgroundColor = [UIColor redColor];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.frame = CGRectMake(x, y, ScreenWidth - x - ZYMallViewControllerMarge, size.height);

    detailLabel.textColor = [UIColor lightGrayColor];
    self.mallDetailLabel = detailLabel;
    [self addSubview:detailLabel];
    
    y = CGRectGetMaxY(self.mallDetailLabel.frame)+ZYMallViewControllerMarge;
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 100, ZYMallViewControllerCellMallPriceHeight)];
    price.text = @"￥12.00";
    price.textColor = [UIColor redColor];
    self.mallPriceLabel = price;
    [self addSubview:self.mallPriceLabel];
    
    x = ScreenWidth - ZYMallViewControllerMarge - ZYMallViewControllerCellBtnWH;
    y = CGRectGetMaxY(self.mallDetailLabel.frame) + 5;
    UIButton *numberPlusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numberPlusBtn.backgroundColor = Color(252, 186, 0, 1.0);
    numberPlusBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    numberPlusBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberPlusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [numberPlusBtn setTitle:@"+" forState:UIControlStateNormal];
    numberPlusBtn.frame = CGRectMake(x, y, ZYMallViewControllerCellBtnWH, ZYMallViewControllerCellBtnWH);
    [numberPlusBtn addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    numberPlusBtn.layer.cornerRadius = ZYMallViewControllerCellBtnWH * 0.5;

    [self addSubview:numberPlusBtn];
    self.numberPlusBtn = numberPlusBtn;
    
    x = ScreenWidth - ZYMallViewControllerMarge - ZYMallViewControllerCellBtnWH - ZYMallViewControllerCellNumberLabelWidth;
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, ZYMallViewControllerCellNumberLabelWidth, ZYMallViewControllerCellNumberLabelHeight)];
//    numberLabel.backgroundColor = [UIColor redColor];
    numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.text = @"";
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    x = ScreenWidth - ZYMallViewControllerMarge - ZYMallViewControllerCellBtnWH - ZYMallViewControllerCellNumberLabelWidth - ZYMallViewControllerCellBtnWH;
    UIButton *numberSubtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [numberSubtractBtn setImage:[UIImage imageNamed:@"mall_plusBtn"] forState:UIControlStateNormal];
    numberSubtractBtn.frame = CGRectMake(x, y, ZYMallViewControllerCellBtnWH, ZYMallViewControllerCellBtnWH);
    numberSubtractBtn.backgroundColor = Color(252, 186, 0, 1.0);
    numberSubtractBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [numberSubtractBtn setTitle:@"-" forState:UIControlStateNormal];
    numberSubtractBtn.layer.cornerRadius = ZYMallViewControllerCellBtnWH * 0.5;
    numberSubtractBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberSubtractBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addSubview:numberSubtractBtn];
    [numberSubtractBtn addTarget:self action:@selector(subtractBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    self.numberSubtractBtn = numberSubtractBtn;
    self.numberSubtractBtn.hidden = YES;
    

    
}

- (void)setGood:(Goods *)good {
    _good = good;
    [self.mallImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,good.images]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.mallNameLabel.text = good.name;
    
    CGFloat x = self.mallDetailLabel.x;
    self.mallDetailLabel.text = good.detail;
    CGSize size = [good.detail boundingRectWithSize:CGSizeMake(ScreenWidth - x - ZYMallViewControllerMarge, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    if (size.height > 15.0) {
        size = CGSizeMake(ScreenWidth - x - ZYMallViewControllerMarge, 30);
    }
    
    self.mallDetailLabel.frame = CGRectMake(x, _mallDetailLabel.y, ScreenWidth - x - ZYMallViewControllerMarge, size.height);
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

























