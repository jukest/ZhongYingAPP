//
//  BoxOfficeTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "BoxOfficeTableViewCell.h"

@implementation BoxOfficeTableViewCell

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
        self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 50, 70) color:[UIColor grayColor]];
        self.movieImg.center = CGPointMake(35, 40);
        [self.contentView addSubview:self.movieImg];
        
        self.movieNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(70, 15, ScreenWidth / 3 -10, 20) text:@"鲁滨逊漂流记" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.movieNameLb];
        
        self.releaseDaysLb = [FanShuToolClass createLabelWithFrame:CGRectMake(70, 45, 100, 10) text:@"上映1天" font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.releaseDaysLb];
        
        self.todayBoxOfficeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 150, 20) text:@"1615.7" font:[UIFont systemFontOfSize:15] textColor:[UIColor redColor] alignment:NSTextAlignmentCenter];
        self.todayBoxOfficeLb.center = CGPointMake(ScreenWidth / 2, 40);
        [self.contentView addSubview:self.todayBoxOfficeLb];
        
        self.historyBoxOfficeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 150, 20) text:@"1615.7" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        self.historyBoxOfficeLb.center = CGPointMake(ScreenWidth / 6 * 5, 40);
        [self.contentView addSubview:self.historyBoxOfficeLb];
    }
    return self;
}

- (void)configCellWithModel:(BoxOffice *)boxOffice
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,boxOffice.cover]] placeholderImage:[UIImage imageNamed:@""]];
    self.movieNameLb.text = boxOffice.name;
    NSDate *date = [NSDate date];
    NSTimeInterval currentInterval = [date timeIntervalSince1970];
    NSTimeInterval spaceInterval = currentInterval -[boxOffice.release_time doubleValue];
    
    if (spaceInterval >= 0) {
        self.releaseDaysLb.text = [NSString stringWithFormat:@"上映%d天",(int)spaceInterval / (3600 * 24)];
    }else{
    self.releaseDaysLb.text = [NSString stringWithFormat:@"距上映%d天",-(int)spaceInterval / (3600 * 24)];
    }
    self.todayBoxOfficeLb.text = boxOffice.today_box_office;
    self.historyBoxOfficeLb.text = boxOffice.all_box_office;
}

@end
