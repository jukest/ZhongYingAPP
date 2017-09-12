//
//  CinemaDtlTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaDtlTableViewCell.h"
#import <CoreText/CoreText.h>
@implementation CinemaDtlTableViewCell

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
        self.startLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15, 65, 22) text:@"" font:[UIFont fontWithName:@"DBLCDTempBlack" size:21] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.startLb.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.startLb];
        
        self.endLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15 +22 +7, 70, 15) text:@"" font:[UIFont systemFontOfSize:13 * widthFloat] textColor:Color(110, 110, 110, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.endLb];
        
        self.typeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +60 +10, 15 +22 -16, 50, 16) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.typeLb];
        
        self.hallNumberLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +60 +10, 15 +22 +7, 36, 15) text:@"" font:[UIFont systemFontOfSize:14 * widthFloat] textColor:Color(110, 110, 110, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.hallNumberLb];
        
        self.priceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +60 +20 +50 +60, 20, 45, 22) text:@"" font:[UIFont systemFontOfSize:16 * widthFloat] textColor:Color(199, 0, 0, 1.0) alignment:NSTextAlignmentRight];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.priceLb.text];
        NSRange range = [self.priceLb.text rangeOfString:@"元"];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * widthFloat] range:range];
        self.priceLb.attributedText = str;
        [self.contentView addSubview:self.priceLb];
        
        self.remainingLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +60 +20 +50 +60 +45 -85, 15 +22 +7, 85, 15) text:@"" font:[UIFont systemFontOfSize:13 * widthFloat] textColor:Color(233, 126, 8, 1.0) alignment:NSTextAlignmentRight];
        //self.remainingLb.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.remainingLb];
        
        self.selectBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -53 -8, 22, 53, 30) title:@"选座" titleColor:[UIColor whiteColor] target:nil action:nil tag:123];
        self.selectBtn.backgroundColor = Color(25, 153, 232, 1.0);
        self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:15 * widthFloat];
        self.selectBtn.layer.cornerRadius = 3.0f;
        self.selectBtn.layer.masksToBounds = YES;
        self.selectBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (void)selectBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoBuyTicketEvent)]) {
        [self.delegate gotoBuyTicketEvent];
    }
}

- (void)configCellWithModel:(Schedule *)schedule
{
    self.endLb.text = [NSString stringWithFormat:@"%@散场",[[NSString stringWithFormat:@"%zd",schedule.end_time] transforTomyyyyMMddWithFormatter:@"HH:mm"]];
    CGSize endSize = [self.endLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * widthFloat]}];
    
    self.startLb.text = [[NSString stringWithFormat:@"%zd",schedule.start_time] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    CGSize startSize = [self.startLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"DBLCDTempBlack" size:21]}];
    self.startLb.frame = CGRectMake(12, 15, endSize.width, startSize.height);
    
    self.typeLb.text = [NSString stringWithFormat:@"%@%@",schedule.language,schedule.tags];
    CGSize typeSize = [self.typeLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * widthFloat]}];
    self.typeLb.frame = CGRectMake(12 +endSize.width +5, 15 +startSize.height -typeSize.height, typeSize.width, typeSize.height);
    self.hallNumberLb.text = schedule.name;
    CGSize hallSize = [self.hallNumberLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 * widthFloat]}];
    self.hallNumberLb.frame = CGRectMake(12 +endSize.width +5 , 15 +22 +7, hallSize.width, 15);
    self.priceLb.text = [NSString stringWithFormat:@"%.2f元",schedule.market_price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.priceLb.text];
    NSRange range = [self.priceLb.text rangeOfString:@"元"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * widthFloat] range:range];
    self.priceLb.attributedText = str;
    self.priceLb.frame = CGRectMake(ScreenWidth -53 -8 -65 -5, 20, 65, 22);
    self.priceLb.textAlignment = NSTextAlignmentRight;
    self.remainingLb.text = [NSString stringWithFormat:@"剩余座位数:%zd",schedule.seat_available_num];
    CGSize remainSize = [self.remainingLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * widthFloat]}];
    self.remainingLb.frame = CGRectMake(ScreenWidth -53 -8 -5 -remainSize.width, 15 +22 +7, remainSize.width, 15);
}

@end
