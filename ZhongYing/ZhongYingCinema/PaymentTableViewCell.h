//
//  PaymentTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/1.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImg;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UIButton *selectbtn;
@property(nonatomic,strong) UILabel *balanceLb;

- (void)configCellWithRemain:(float)remain;

@end
