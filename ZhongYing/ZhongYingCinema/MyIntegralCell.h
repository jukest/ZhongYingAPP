//
//  MyIntegralCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/9.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shop.h"

@interface MyIntegralCell : UITableViewCell

@property(nonatomic,strong) UIImageView *goodsImg;
@property(nonatomic,strong) UILabel *goodsTypeLb;
@property(nonatomic,strong) UILabel *goodsNameLb;
@property(nonatomic,strong) UILabel *integralLb;

- (void)configCellWithModel:(Shop *)shop;

@end
