//
//  ConfirmPackageOrderViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/3.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"
#import "Goods.h"
#import "Cinema.h"

typedef NS_ENUM(NSInteger,ConfirmPackageOrderViewCtlEvents){
    AmountMinusEvent = 123,
    AmountAddEvent,
    CouponEvent,
    GotoPayEvent,
};
@interface ConfirmPackageOrderViewCtl : ZYViewController

@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *packageLb;
@property(nonatomic,strong) UILabel *unitPriceLb;
@property(nonatomic,strong) UIButton *minusBtn;
@property(nonatomic,strong) UITextField *amountFld;
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) UIButton *couponLb;
@property(nonatomic,strong) UILabel *totalPricrLb;
@property(nonatomic,strong) UILabel *tipsLb;
@property(nonatomic,strong) UIButton *gotoPayBtn;
@property(nonatomic,strong) Goods *goods;
@property(nonatomic,strong) Cinema *cinemaMsg;


@end
