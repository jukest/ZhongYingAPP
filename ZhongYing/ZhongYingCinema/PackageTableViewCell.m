//
//  PackageTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "PackageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface PackageTableViewCell ()<UITextFieldDelegate>

@property(nonatomic,strong) UIButton *minusBtn;
@property(nonatomic,strong) UIButton *addBtn;

@end
@implementation PackageTableViewCell

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
        self.packageImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 10, 48, 48) color:[UIColor grayColor]];
        self.packageImg.image = [UIImage imageNamed:@"cinema_package"];
        [self.contentView addSubview:self.packageImg];
        
        self.packageContent = [FanShuToolClass createLabelWithFrame:CGRectMake(68, 12, 200, 20) text:@"中爆米花1份+小可乐一杯" font:[UIFont systemFontOfSize:17 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.packageContent];
        
        self.packagePrice = [FanShuToolClass createLabelWithFrame:CGRectMake(68, 12+20+7, 50, 15) text:@"15元" font:[UIFont systemFontOfSize:16 * widthFloat] textColor:Color(199, 0, 0, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.packagePrice];
        
        self.selectBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -53 -8, 15, 53, 30) title:@"选择" titleColor:[UIColor whiteColor] target:nil action:nil tag:123];
        self.selectBtn.backgroundColor = Color(252, 186, 0, 1.0);
        self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.selectBtn.layer.cornerRadius = 3.0f;
        self.selectBtn.layer.masksToBounds = YES;
        self.selectBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.selectBtn];
        
        self.amountView = [FanShuToolClass createViewWithFrame:CGRectMake(ScreenWidth -120, 22, 105, 22) backgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.amountView];
        
        self.amountFld = [FanShuToolClass createTextFieldWithFrame:CGRectMake(22 +5, 0, 50, 22) textColor:Color(59, 160, 250, 1.0) font:[UIFont systemFontOfSize:14] target:self];
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
        
        self.minusBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 22, 22) title:@"-" titleColor:[UIColor whiteColor] target:self action:@selector(selectBtnDidClicked:) tag:124];
        self.minusBtn.backgroundColor = Color(59, 160, 250, 1.0);
        [self.minusBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
        self.minusBtn.layer.cornerRadius = 3.0;
        self.minusBtn.layer.masksToBounds = YES;
        [self.amountView addSubview:self.minusBtn];
        
        self.addBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(22 +5 +50 +5, 0, 22, 22) title:@"+" titleColor:[UIColor whiteColor] target:self action:@selector(selectBtnDidClicked:) tag:125];
        self.addBtn.backgroundColor = Color(59, 160, 250, 1.0);
        [self.addBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
        self.addBtn.layer.cornerRadius = 3.0;
        self.addBtn.layer.masksToBounds = YES;
        [self.amountView addSubview:self.addBtn];
    }
    return self;
}

- (void)selectBtnDidClicked:(UIButton *)btn
{
    if (btn.tag == 123) {
        if ([self.delegate respondsToSelector:@selector(gotoBuyPackageEvent)]) {
            [self.delegate gotoBuyPackageEvent];
        }
    }else if (btn.tag == 124){
        if (![self.amountFld.text isEqualToString:@"0"]) {
            self.amountFld.text = [NSString stringWithFormat:@"%zd",[self.amountFld.text integerValue] -1];
            if ([self.delegate respondsToSelector:@selector(gotoPackageAmountChangeEvent:indexPath:)]) {
                [self.delegate gotoPackageAmountChangeEvent:[self.amountFld.text integerValue] indexPath:_index];
            }
        }
    }else if (btn.tag == 125){
        if (![self.amountFld.text isEqualToString:@"9"]) {
            self.amountFld.text = [NSString stringWithFormat:@"%zd",[self.amountFld.text integerValue] +1];
            if ([self.delegate respondsToSelector:@selector(gotoPackageAmountChangeEvent:indexPath:)]) {
                [self.delegate gotoPackageAmountChangeEvent:[self.amountFld.text integerValue] indexPath:_index];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(gotoPackageAmountUpperLimitEvent)]) {
                [self.delegate gotoPackageAmountUpperLimitEvent];
            }
        }
    }
}

- (void)textFieldValueDidChange:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(gotoPackageAmountChangeEvent:indexPath:)]) {
        [self.delegate gotoPackageAmountChangeEvent:[self.amountFld.text integerValue] indexPath:_index];
    }
}

- (void)configCellWithModel:(Goods *)goods
{
    [self.packageImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,goods.images]] placeholderImage:[UIImage imageNamed:@"cinema_package"]];
    //CGRectMake(68, 12, 200, 20)
    CGSize detailSize = [goods.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    self.packageContent.text = goods.name;
    self.packagePrice.text = [NSString stringWithFormat:@"%zd元",goods.price];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

@end
