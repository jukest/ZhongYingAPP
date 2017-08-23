//
//  MyBillCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/6.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@interface MyBillCell : UITableViewCell

@property(nonatomic,strong) UILabel *weekLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UIImageView *billImg;
@property(nonatomic,strong) UILabel *priceLb;
@property(nonatomic,strong) UILabel *billDetailsLb;

- (void)configCellWithModel:(Bill *)bill;

@end
