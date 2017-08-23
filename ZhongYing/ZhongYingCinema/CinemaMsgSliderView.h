//
//  CinemaMsgSliderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@protocol CinemaMsgSliderDelegate <NSObject>

- (void)gotoChangeCinemaEvent;

@end

@interface CinemaMsgSliderView : UIView<SDCycleScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *imageArr;
@property(nonatomic,strong) SDCycleScrollView *adView;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,weak) id<CinemaMsgSliderDelegate> delegate;

- (void)configCellWithArray:(NSMutableArray *)picArr CinemaName:(NSString *)name;

@end
