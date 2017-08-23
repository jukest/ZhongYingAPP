//
//  BoxOfficeTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxOffice.h"

@interface BoxOfficeTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *movieNameLb;
@property(nonatomic,strong) UILabel *releaseDaysLb;
@property(nonatomic,strong) UILabel *todayBoxOfficeLb;
@property(nonatomic,strong) UILabel *historyBoxOfficeLb;

- (void)configCellWithModel:(BoxOffice *)boxOffice;

@end
