//
//  MoviesSliderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

@protocol MovieSliderViewDelegate <NSObject>

- (void)MovieDidChanged:(NSInteger)index;

@end
@interface MoviesSliderView : UIView

@property(nonatomic,strong) NewPagedFlowView *pageFlowView;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) NSArray *picArr;
@property(nonatomic,weak) id<MovieSliderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame picArr:(NSArray *)picArr index:(NSInteger)index;

@end
