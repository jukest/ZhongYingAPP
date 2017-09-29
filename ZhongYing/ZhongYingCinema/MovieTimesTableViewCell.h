//
//  MovieTimesTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@protocol MovieTimesTableViewCellDelegate <NSObject>

- (void)gotoSelectedMovieTimeIndexPath:(NSIndexPath *)indexPath;

@end
@interface MovieTimesTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *startLb;
@property(nonatomic,strong) UILabel *endLb;
@property(nonatomic,strong) UILabel *typeLb;
@property(nonatomic,strong) UILabel *hallNumberLb;
@property(nonatomic,strong) UILabel *priceLb;
@property(nonatomic,strong) UILabel *remainingLb;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) NSIndexPath *indexPath;

@property(nonatomic,strong) NSString *serviceMoney;//服务费

@property(nonatomic,weak) id<MovieTimesTableViewCellDelegate> delegate;

- (void)configCellWithModel:(Schedule *)schedule;

@end
