
//
//  FilmHeatTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "FilmHeatTableViewCell.h"

@implementation FilmHeatTableViewCell

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
        
        self.todayBoxOfficeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 150, 20) text:@"161" font:[UIFont systemFontOfSize:15] textColor:[UIColor redColor] alignment:NSTextAlignmentCenter];
        self.todayBoxOfficeLb.center = CGPointMake(ScreenWidth / 2, 40);
        [self.contentView addSubview:self.todayBoxOfficeLb];
        
        self.historyBoxOfficeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 150, 20) text:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        self.historyBoxOfficeLb.center = CGPointMake(ScreenWidth / 6 * 5, 40);
        [self.contentView addSubview:self.historyBoxOfficeLb];
        
        self.rankImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 25, 25) color:[UIColor whiteColor]];
        self.rankImg.center = CGPointMake(ScreenWidth / 6 * 5, 40);
        self.rankImg.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.rankImg];
    }
    return self;
}

- (void)configCellWithModel:(HeatFilm *)film
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,film.cover]] placeholderImage:[UIImage imageNamed:@""]];
    self.movieNameLb.text = film.name;
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval = currentInterval - [film.release_time doubleValue];
    int i = (int)interval / 3600;
    if (i == 0) {
        self.releaseDaysLb.text = @"上映1天";
    }else if (i / 24 == 0){
        self.releaseDaysLb.text = @"上映1天";
    }else{
        self.releaseDaysLb.text = [NSString stringWithFormat:@"上映%zd天",i / 24];
    }
    self.todayBoxOfficeLb.text = [NSString stringWithFormat:@"%zd",film.comments];
}

@end
