//
//  MoreCinemaTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MoreCinemaTableViewCell.h"

@implementation MoreCinemaTableViewCell

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
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 * widthFloat, 12 * heightFloat, 300 * widthFloat, 20 * heightFloat) text:@"中影UL城市影院(乐尚店)" font:[UIFont systemFontOfSize:18 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.nameLb];
        
        self.addressLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 * widthFloat, (12 +20 +10) * heightFloat, ScreenWidth -112 * widthFloat, 16 * heightFloat) text:@"宝安区裕安一路与翻身路交叉口乐尚生活广场" font:[UIFont systemFontOfSize:16 * widthFloat] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.addressLb];
        
        self.distanceView = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -100 * widthFloat, (12 +20 +15) * heightFloat, 70, 20 * heightFloat) title:@"" titleColor:Color(70, 70, 70, 1.0) target:nil action:nil tag:1000];
        self.distanceView.center = CGPointMake(ScreenWidth -(100 -50) * widthFloat, self.addressLb.center.y);
        self.distanceView.titleLabel.font = [UIFont systemFontOfSize:15 * widthFloat];
        [self.distanceView setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [self.distanceView setImage:[UIImage imageNamed:@"cinema_address"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.distanceView];
    }
    return self;
}

- (void)configCellWithModel:(Cinema *)cinema
{
    self.nameLb.text = cinema.title;
    self.addressLb.text = cinema.address;
    
    NSString *distance;
    if ([cinema.distance integerValue] < 500) {
        distance = @"<500m";
    }else if([cinema.distance integerValue] >= 500 && [cinema.distance integerValue] < 1000){
        distance = [NSString stringWithFormat:@" %@m",cinema.distance];
    }else if ([cinema.distance integerValue] >= 1000 && [cinema.distance integerValue] < 10000){
        distance = [NSString stringWithFormat:@"%.1fkm",[cinema.distance floatValue] / 1000];
    }else if ([cinema.distance integerValue] >= 10000 && [cinema.distance integerValue] < 99000){
        distance = [NSString stringWithFormat:@" %zdkm",[cinema.distance integerValue] / 1000];
    }else{
        distance = @">99km";
    }
    [self.distanceView setTitle:distance forState:UIControlStateNormal];
}

@end
