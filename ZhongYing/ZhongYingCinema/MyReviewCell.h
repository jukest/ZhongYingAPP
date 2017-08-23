//
//  MyReviewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/6.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFilmComment.h"

@protocol MyReviewCellDelegate <NSObject>

- (void)MovieViewDidSelectedIndexPath:(NSIndexPath *)indexPath;

@end
@interface MyReviewCell : UITableViewCell

@property(nonatomic,strong) UIView *starsView;
@property(nonatomic,strong) UILabel *markLb;
@property(nonatomic,strong) UILabel *reviewDateLb;
@property(nonatomic,strong) UILabel *reviewLb;
@property(nonatomic,strong) UIView *movieView;
@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *movieNameLb;
@property(nonatomic,strong) UILabel *addressLb;
@property(nonatomic,strong) UILabel *hallLb;
@property(nonatomic,strong) UILabel *releaseDateLb;
@property(nonatomic,strong) UILabel *releaseTimeLb;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) id <MyReviewCellDelegate>delegate;

- (void)configCellWithModel:(MyFilmComment *)comment;

@end
