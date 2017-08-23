//
//  MoreCinemaTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cinema.h"
@interface MoreCinemaTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *addressLb;
@property(nonatomic,strong) UIButton *distanceView;

- (void)configCellWithModel:(Cinema *)cinema;

@end
