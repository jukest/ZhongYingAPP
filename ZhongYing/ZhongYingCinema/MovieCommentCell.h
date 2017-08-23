//
//  MovieCommentCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmComment.h"

@interface MovieCommentCell : UITableViewCell

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UIView *starView;
@property(nonatomic,strong) UILabel *markLb;
@property(nonatomic,strong) UILabel *commentLb;

- (void)configCellWithModel:(FilmComment *)comment;

@end
