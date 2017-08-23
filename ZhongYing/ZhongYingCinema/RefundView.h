//
//  RefundView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefundViewDelegate <NSObject>

- (void)gotoRefundViewEvents:(NSInteger)tag;

@end
@interface RefundView : UIView

@property(nonatomic,strong) id <RefundViewDelegate> delegate;
@property(nonatomic,strong) UILabel *headerView;
@property(nonatomic,strong) UILabel *contentView;

- (instancetype)initWithFrame:(CGRect)frame WithContent:(NSString *)content;

- (void)show;

- (void)hiddenView;

@end
