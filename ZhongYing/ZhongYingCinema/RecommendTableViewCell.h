//
//  RecommendTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/5.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Souvenir.h"

typedef NS_ENUM(NSInteger,RecommendTableViewCellEvent){
    RecommendAmountMinusEvent = 101,
    RecommendAmountAddEvent,
};

@protocol RecommendTableViewCellDelegate <NSObject>

- (void)gotoRecommendAmountChanged:(NSInteger)amount indexPath:(NSIndexPath *)index;

@end
@interface RecommendTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *packageImg;
@property(nonatomic,strong) UILabel *packageContent;
@property(nonatomic,strong) UILabel *packagePrice;
@property(nonatomic,strong) UIView *amountView;
@property(nonatomic,strong) UITextField *amountFld;
@property(nonatomic,strong) NSIndexPath *index;
@property(nonatomic,weak) id<RecommendTableViewCellDelegate> delegate;

- (void)configCellWithModel:(Souvenir *)souvenir;

@end
