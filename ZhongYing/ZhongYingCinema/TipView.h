//
//  TipView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/3/8.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipView : UIView

@property(nonatomic,strong) UILabel *remainTimeLb;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *releaseDateLb;
@property(nonatomic,strong) UILabel *cinemaNameLb;
@property(nonatomic,strong) UILabel *seatsLb;
@property(nonatomic,strong) UILabel *codeLb;
@property(nonatomic,strong) UIImageView *codeImg;
@property(nonatomic,strong) UIButton *closeBtn;

- (void)show;

- (void)hiddenView;

- (void)configTipView:(NSDictionary *)dict;

@end
