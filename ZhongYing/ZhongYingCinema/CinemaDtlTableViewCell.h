//
//  CinemaDtlTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@protocol CinemaDtlTavleViewCellDelegate <NSObject>

- (void)gotoBuyTicketEvent;

@end
@interface CinemaDtlTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *startLb;
@property(nonatomic,strong) UILabel *endLb;
@property(nonatomic,strong) UILabel *typeLb;
@property(nonatomic,strong) UILabel *hallNumberLb;
@property(nonatomic,strong) UILabel *priceLb;
@property(nonatomic,strong) UILabel *remainingLb;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,weak) id<CinemaDtlTavleViewCellDelegate> delegate;

- (void)configCellWithModel:(Schedule *)schedule;

@end
