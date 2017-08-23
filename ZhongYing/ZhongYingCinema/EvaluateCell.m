//
//  EvaluateCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "EvaluateCell.h"

@implementation EvaluateCell

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
        self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 11, 66, 91) image:[UIImage imageNamed:@""] tag:100];
        [self.contentView addSubview:self.movieImg];
        
        self.movieNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +66 +13, 21, 200, 20) text:@"鲁滨逊漂流记" font:[UIFont systemFontOfSize:18] textColor:Color(50, 50, 50, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.movieNameLb];
        
        NSString *cinemaName = @"中影星趴国际影城";
        CGSize cinemaSize = [cinemaName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        self.cinemaNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +66 +13, 21 +20 +15, cinemaSize.width, 15) text:cinemaName font:[UIFont systemFontOfSize:16] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.cinemaNameLb];
        
        self.hallLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +66 +13 +self.cinemaNameLb.frame.size.width +8, 21 +20 +15, 50, 15) text:@"3号厅" font:[UIFont systemFontOfSize:16] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.hallLb];
        
        self.timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +66 +13, 21 +20 +15 +15 +7, 150, 14) text:@"2016-11-03" font:[UIFont systemFontOfSize:16] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLb];
        
        self.markBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -65, 42.5, 50, 30) title:@"评分" titleColor:[UIColor whiteColor] cornerRadius:3 font:[UIFont systemFontOfSize:14] backgroundColor:Color(252, 186, 0, 1.0) target:self action:@selector(markBtnDidClicked:) tag:101];
        [self.contentView addSubview:self.markBtn];
    }
    return self;
}

- (void)markBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoMarkEventWithIndexPath:)]) {
        [self.delegate gotoMarkEventWithIndexPath:self.indexPath];
    }
}

- (void)configCellWithModel:(Evaluate *)evaluate
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,evaluate.cover]] placeholderImage:[UIImage imageNamed:@""]];
    self.movieNameLb.text = evaluate.name;
    self.cinemaNameLb.text = evaluate.cinema_name;
    CGSize cinemaSize = [evaluate.cinema_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.cinemaNameLb.frame = CGRectMake(12 +66 +13, 21 +20 +15, cinemaSize.width, 15);
    self.hallLb.text = evaluate.hall_name;
    CGSize hallSize = [evaluate.hall_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.hallLb.frame = CGRectMake(12 +66 +13 +self.cinemaNameLb.frame.size.width +8, 21 +20 +15, hallSize.width > (ScreenWidth -self.cinemaNameLb.frame.size.width -99 -65) ? (ScreenWidth -self.cinemaNameLb.frame.size.width -99 -65) : hallSize.width, 15);
    self.timeLb.text = [[NSString stringWithFormat:@"%zd",evaluate.start_time] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"];
}

@end
