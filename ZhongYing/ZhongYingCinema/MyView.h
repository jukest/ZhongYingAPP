//
//  MyView.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/16.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyViewDelegate <NSObject>

- (void)MyViewDelegateWithTag:(NSInteger)tag;
- (void)MyViewDelegateClickHead;

@end

@interface MyView : UIView

@property (nonatomic,strong) UIImageView *myHeadImg;
@property (nonatomic,strong) UILabel *myUsernameLb;
@property (nonatomic,strong) UIButton *myBalanceLb;
@property (nonatomic,strong) UIButton *myIntegralLb;
@property (nonatomic,strong) UIButton *myRechargeBtn;
@property (nonatomic,strong) UIButton *myOrderBtn;
@property (nonatomic,strong) UIButton *myEvaluateBtn;
@property (nonatomic,weak) id<MyViewDelegate> delegate;

- (void)configMyViewWithContent:(NSDictionary *)content;

@end
