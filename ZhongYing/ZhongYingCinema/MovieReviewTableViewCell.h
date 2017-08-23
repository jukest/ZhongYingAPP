//
//  MovieReviewTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieComment.h"

@interface MovieReviewTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImg;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UILabel *markLb;
@property(nonatomic,strong) UILabel *createTimeLb;

- (void)configCellWithComment:(MovieComment *)comment;

@end
