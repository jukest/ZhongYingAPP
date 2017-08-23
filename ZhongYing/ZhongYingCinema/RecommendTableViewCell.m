//
//  RecommendTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/5.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

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
        self.packageImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 18.5, 48, 48) image:[UIImage imageNamed:@"cinema_package"] tag:100];
        [self.contentView addSubview:self.packageImg];
        
        self.packageContent = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +48 +10, 20, 200, 15) text:@"小黄人公仔" font:[UIFont systemFontOfSize:16] textColor:Color(26, 26, 26, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.packageContent];
        
        self.packagePrice = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +48 +10, 20 +15 +7, 80, 15) text:@"15元" font:[UIFont systemFontOfSize:14] textColor:Color(247, 86, 109, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.packagePrice];
        
        self.amountView = [FanShuToolClass createViewWithFrame:CGRectMake(ScreenWidth -180, 20 +15 +7, 180 -35, 30) backgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.amountView];
        
        UIButton *minusBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 30, 30) title:@"-" titleColor:[UIColor whiteColor] target:self action:@selector(amountChanged:) tag:RecommendAmountMinusEvent];
        minusBtn.backgroundColor = Color(59, 160, 250, 1.0);
        [minusBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
        minusBtn.layer.cornerRadius = 3.0;
        minusBtn.layer.masksToBounds = YES;
        [self.amountView addSubview:minusBtn];
        
        self.amountFld = [FanShuToolClass createTextFieldWithFrame:CGRectMake(30 +10, 0, 65, 30) textColor:Color(59, 160, 250, 1.0) font:[UIFont systemFontOfSize:16] target:self];
        self.amountFld.keyboardType = UIKeyboardTypeNumberPad;
        self.amountFld.text = @"0";
        self.amountFld.clearButtonMode = UITextFieldViewModeNever;
        self.amountFld.layer.borderWidth = 0.5;
        self.amountFld.layer.borderColor = Color(59, 160, 250, 1.0).CGColor;
        self.amountFld.layer.cornerRadius = 3.0;
        self.amountFld.layer.masksToBounds = YES;
        self.amountFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.amountFld.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.amountFld.textAlignment = NSTextAlignmentCenter;
        [self.amountFld addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.amountView addSubview:self.amountFld];
        
        UIButton *addBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(30 +10 +65 +10, 0, 30, 30) title:@"+" titleColor:[UIColor whiteColor] target:self action:@selector(amountChanged:) tag:RecommendAmountAddEvent];
        addBtn.backgroundColor = Color(59, 160, 250, 1.0);
        [addBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
        addBtn.layer.cornerRadius = 3.0;
        addBtn.layer.masksToBounds = YES;
        [self.amountView addSubview:addBtn];
    }
    return self;
}

- (void)amountChanged:(UIButton *)btn
{
    if (btn.tag == RecommendAmountMinusEvent){
        if (![self.amountFld.text isEqualToString:@"0"]) {
            self.amountFld.text = [NSString stringWithFormat:@"%zd",[self.amountFld.text integerValue] -1];
        }
    }else if (btn.tag == RecommendAmountAddEvent){
        self.amountFld.text = [NSString stringWithFormat:@"%zd",[self.amountFld.text integerValue] +1];
    }
    if ([self.delegate respondsToSelector:@selector(gotoRecommendAmountChanged:indexPath:)]) {
        [self.delegate gotoRecommendAmountChanged:[self.amountFld.text integerValue] indexPath:_index];
    }
}

- (void)textFieldValueDidChange:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(gotoRecommendAmountChanged:indexPath:)]) {
        [self.delegate gotoRecommendAmountChanged:[self.amountFld.text integerValue] indexPath:_index];
    }
}

- (void)configCellWithModel:(Souvenir *)souvenir
{
    [self.packageImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,souvenir.images]] placeholderImage:[UIImage imageNamed:@""]];
    self.packageContent.text = souvenir.detail;
    self.packagePrice.text = [NSString stringWithFormat:@"%@元",souvenir.price];
}

@end
