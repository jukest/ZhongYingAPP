//
//  PaymentTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/1.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell

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
        self.iconImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(15, 13, 25, 25) color:[UIColor clearColor]];
        [self.contentView addSubview:self.iconImg];
        
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15 +25 +17, 25 -7.5, 150, 15) text:@"" font:[UIFont systemFontOfSize:16 * widthFloat] textColor:Color(19, 19, 19, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLb];
        
        self.selectbtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -25 -25, 25 -12.5, 25, 25) image:[UIImage imageNamed:@"payment_not_select"] target:nil action:nil tag:1000];
        self.selectbtn.userInteractionEnabled = NO;
        [self.selectbtn setImage:[UIImage imageNamed:@"payment_select"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectbtn];
        
        self.balanceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -25 -25 -10 -90, 25 -8.5, 90, 17) text:@"余额：90元" font:[UIFont systemFontOfSize:16 * widthFloat] textColor:Color(19, 19, 19, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.balanceLb];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.balanceLb.text];
        NSRange range = [self.balanceLb.text rangeOfString:@"余额："];
        [str addAttribute:NSForegroundColorAttributeName value:Color(248, 91, 118, 1.0) range:NSMakeRange(range.length, [self.balanceLb.text length] -range.length)];
        self.balanceLb.attributedText = str;
    }
    return self;
}

- (void)configCellWithRemain:(float)remain
{
    self.balanceLb.text = [NSString stringWithFormat:@"余额：%.2f元",remain];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.balanceLb.text];
    NSRange range = [self.balanceLb.text rangeOfString:@"余额："];
    [str addAttribute:NSForegroundColorAttributeName value:Color(248, 91, 118, 1.0) range:NSMakeRange(range.length, [self.balanceLb.text length] -range.length)];
    self.balanceLb.attributedText = str;
    CGSize balance = [self.balanceLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 * widthFloat]}];
    self.balanceLb.frame = CGRectMake(ScreenWidth -25 -25 -10 -balance.width, 25 -8.5, balance.width, 17);
}

@end
