//
//  FilmHeatTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeatFilm.h"

@interface FilmHeatTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *movieNameLb;
@property(nonatomic,strong) UILabel *releaseDaysLb;
@property(nonatomic,strong) UILabel *todayBoxOfficeLb;
@property(nonatomic,strong) UILabel *historyBoxOfficeLb;
@property(nonatomic,strong) UIImageView *rankImg;

- (void)configCellWithModel:(HeatFilm *)film;

@end
