//
//  ZYMallCell.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@protocol ZYMallCellDelegate <NSObject>

@optional
- (void)mallCell:(UITableViewCell *)cell plusBtnDidClick:(UIButton *)button withNumberOfGood:(NSInteger)number; 
- (void)mallCell:(UITableViewCell *)cell subtractBtnDidClick:(UIButton *)button withNumberOfGood:(NSInteger)number;
- (void)mallCell:(UITableViewCell *)cell imageViewDidClick:(UIImageView *)imageView;

@end

@interface ZYMallCell : UITableViewCell
@property (nonatomic,strong) Goods *good;

@property (nonatomic, weak) id <ZYMallCellDelegate> delegate;
@end
