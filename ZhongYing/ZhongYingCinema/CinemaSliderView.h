//
//  CinemaSliderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/24.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaTitleView.h"
#import "SDCycleScrollView.h"
#import "Cinema.h"
typedef NS_ENUM(NSInteger,CinemaSliderEvents){
    MoreCinemaEvent = 200,
    CinemaMessageEvent,
};
@protocol CinemaSliderViewDelegate <NSObject>

- (void)gotoCinemaSliderEventsWithTag:(CinemaSliderEvents)event;

@end
@interface CinemaSliderView : UIView<SDCycleScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *imageArr;
@property(nonatomic,strong) SDCycleScrollView *adView;
@property(nonatomic,strong) UILabel *cinemaNameLb;
@property(nonatomic,strong) UILabel *cinemaAddressLb;
@property(nonatomic,strong) CinemaTitleView *titleView;
@property(nonatomic,weak) id<CinemaSliderViewDelegate> delegate;

- (void)configCellWithArray:(NSMutableArray *)picArr cinemaMsg:(Cinema *)cinemaMsg;

@end
