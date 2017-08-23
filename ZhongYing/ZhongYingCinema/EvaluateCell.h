//
//  EvaluateCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Evaluate.h"

@protocol EvaluateCellDelegate<NSObject>

- (void)gotoMarkEventWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface EvaluateCell : UITableViewCell

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *movieNameLb;
@property(nonatomic,strong) UILabel *cinemaNameLb;
@property(nonatomic,strong) UILabel *hallLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UIButton *markBtn;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) id<EvaluateCellDelegate> delegate;

- (void)configCellWithModel:(Evaluate *)evaluate;

@end
