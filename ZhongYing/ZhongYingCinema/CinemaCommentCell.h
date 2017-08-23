//
//  CinemaCommentCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaComment.h"

@interface CinemaCommentCell : UITableViewCell

@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UIView *starView;
@property(nonatomic,strong) UILabel *markLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UILabel *commentLb;

- (void)configCellWithModel:(CinemaComment *)cinemaComment;

@end
