//
//  ZYZYMemberViewControllerTableViewHeaderView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYZYMemberViewControllerTableViewHeaderView;


typedef NS_ENUM(NSUInteger, MyMemberCardButtonType) {
    MyBalanceButtonType = 30,
    MyIntegralButtonType,
    MyCouponButtonType,
};

@protocol ZYZYMemberViewControllerTableViewHeaderViewDelegate <NSObject>

@optional
- (void)tableViewHeaderView:(ZYZYMemberViewControllerTableViewHeaderView *)headerView didClickButton:(UIButton *)button type:(MyMemberCardButtonType)buttonType;

@end




@interface ZYZYMemberViewControllerTableViewHeaderView : UIView

@property (nonatomic,strong) NSMutableArray <UIButton *> *buttons;

@property (nonatomic, weak) id <ZYZYMemberViewControllerTableViewHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSString *couponStr;

@property (nonatomic, strong) NSString *integralStr;

@property (nonatomic, strong) NSString *balanceStr;
@end
