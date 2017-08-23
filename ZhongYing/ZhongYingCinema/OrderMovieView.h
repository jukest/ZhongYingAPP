//
//  OrderMovieView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/27.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMovieView : UIView

@property(nonatomic,strong) UIImageView *orderImg;
@property(nonatomic,strong) UILabel *priceLb;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *timeAndHallLb;
@property(nonatomic,strong) UILabel *seatsLb;

- (instancetype)initWithFrame:(CGRect)frame movieMessage:(NSDictionary *)movie;

@end
