//
//  PackageTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@protocol PackageTableViewCellDelegate <NSObject>

@optional

- (void)gotoBuyPackageEvent;

- (void)gotoPackageAmountChangeEvent:(NSInteger)amount indexPath:(NSIndexPath *)index;

- (void)gotoPackageAmountUpperLimitEvent;

@end
@interface PackageTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *packageImg;
@property(nonatomic,strong) UILabel *packageContent;
@property(nonatomic,strong) UILabel *packagePrice;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) UIView *amountView;
@property(nonatomic,strong) NSIndexPath *index;
@property(nonatomic,strong) UITextField *amountFld;
@property(nonatomic,weak) id<PackageTableViewCellDelegate> delegate;

- (void)configCellWithModel:(Goods *)goods;

@end
