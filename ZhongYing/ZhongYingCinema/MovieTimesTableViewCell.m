//
//  MovieTimesTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieTimesTableViewCell.h"

@implementation MovieTimesTableViewCell

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
        self.startLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10, 15, 60, 22) text:@"" font:[UIFont fontWithName:@"DBLCDTempBlack" size:18 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.startLb];
        
        self.endLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10, 15 +22 +6, 60, 15) text:@"" font:[UIFont systemFontOfSize:12 * widthFloat] textColor:Color(90, 90, 90, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.endLb];
        
        self.typeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10 +55 +18, 15 +22 -16, 50, 16) text:@"" font:[UIFont systemFontOfSize:11 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.typeLb];
        
        self.hallNumberLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10 +55 +18, 15 +22 +5, 36, 15) text:@"" font:[UIFont systemFontOfSize:11 * widthFloat] textColor:Color(90, 90, 90, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.hallNumberLb];
        
        self.priceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10 +55 +18 +40 +55, 15, 45, 22) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(199, 0, 0, 1.0) alignment:NSTextAlignmentRight];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.priceLb.text];
        NSRange range = [self.priceLb.text rangeOfString:@"元"];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * widthFloat] range:range];
        self.priceLb.attributedText = str;
        [self.contentView addSubview:self.priceLb];
        
        self.remainingLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10 +55 +18 +40 +55 +45 -85, 15 +22 +6, 85, 15) text:@"" font:[UIFont systemFontOfSize:11 * widthFloat] textColor:Color(233, 126, 8, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.remainingLb];
        
        self.selectBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -58 -50 * widthFloat -12, 18, 50 * widthFloat, 30 * heightFloat) title:@"" titleColor:[UIColor whiteColor] target:self action:@selector(selectBtnDidClicked:) tag:123];
        self.selectBtn.backgroundColor = Color(25, 153, 232, 1.0);
        self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:10 * widthFloat];
        self.selectBtn.layer.cornerRadius = 3.0f;
        self.selectBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (void)configCellWithModel:(Schedule *)schedule
{
    self.endLb.text = [NSString stringWithFormat:@"%@散场",[[NSString stringWithFormat:@"%zd",schedule.end_time] transforTomyyyyMMddWithFormatter:@"HH:mm"]];
    CGSize endSize = [self.endLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 * widthFloat]}];
    self.endLb.frame = CGRectMake(10, 15 +22 +6, endSize.width, 15);
    
    self.startLb.text = [[NSString stringWithFormat:@"%zd",schedule.start_time] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    CGSize startSize = [self.startLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"DBLCDTempBlack" size:18]}];
    self.startLb.frame = CGRectMake(10, 15, endSize.width, startSize.height);
    
    //self.startLb.text = [[NSString stringWithFormat:@"%zd",schedule.start_time] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    //self.endLb.text = [NSString stringWithFormat:@"%@散场",[[NSString stringWithFormat:@"%zd",schedule.end_time] transforTomyyyyMMddWithFormatter:@"HH:mm"]];
    if (schedule.tags) {
        self.typeLb.text = [NSString stringWithFormat:@"%@%@",schedule.language,schedule.tags];
    }else{
        self.typeLb.text = [NSString stringWithFormat:@"%@",schedule.language];
    }
    CGSize typeSize = [self.typeLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11 * widthFloat]}];
    self.typeLb.frame = CGRectMake(10 +60, 15 +startSize.height -16, typeSize.width, 16);
    self.hallNumberLb.text = schedule.name;
    CGSize hallSize = [self.hallNumberLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11 * widthFloat]}];
    self.hallNumberLb.frame = CGRectMake(10 +60, 15 +22 +6, hallSize.width, 15);
    self.priceLb.text = [NSString stringWithFormat:@"%zd元",schedule.market_price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.priceLb.text];
    NSRange range = [self.priceLb.text rangeOfString:@"元"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11 * widthFloat] range:range];
    self.priceLb.attributedText = str;
    self.priceLb.frame = CGRectMake(ScreenWidth -58 -50 * widthFloat -12 -45 -8, 15, 45, 22);
    self.remainingLb.text = [NSString stringWithFormat:@"剩余座位数:%zd",schedule.seat_available_num];
    CGSize remainSize = [self.remainingLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11 * widthFloat]}];
    self.remainingLb.frame = CGRectMake(ScreenWidth -58 -50 * widthFloat -12 -remainSize.width -8, 15 +22 +7, remainSize.width, 15);
    if ([schedule.is_now boolValue]) {
        [self.selectBtn setTitle:@"当前场次" forState:UIControlStateNormal];
        self.selectBtn.backgroundColor = Color(252, 186, 0, 1.0);
        self.selectBtn.enabled = NO;
    }else{
        [self.selectBtn setTitle:@"选座购票" forState:UIControlStateNormal];
        self.selectBtn.backgroundColor = Color(25, 153, 232, 1.0);
        self.selectBtn.enabled = YES;
    }
}

- (void)selectBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoSelectedMovieTimeIndexPath:)]) {
        [self.delegate gotoSelectedMovieTimeIndexPath:self.indexPath];
    }
}

@end
