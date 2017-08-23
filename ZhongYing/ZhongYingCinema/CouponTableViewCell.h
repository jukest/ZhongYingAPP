//
//  CouponTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/1.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

@interface CouponTableViewCell : UITableViewCell

@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) UILabel *amountLb;
@property(nonatomic,strong) UILabel *typeLb;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *descriptionLb;
@property(nonatomic,strong) UILabel *effectiveDateLb;
@property(nonatomic,strong) UIImageView *useImg;
@property(nonatomic,strong) UIImageView *backgroundImg;

- (void)configCellWithModel:(Coupon *)coupon;

@end