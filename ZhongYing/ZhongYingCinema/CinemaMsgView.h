//
//  CinemaMsgView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cinema.h"

typedef NS_ENUM(NSInteger, CinemaMsgViewEvents){
    CinemaDetailsEvent = 221,
    CinemaMapEvent,
};

@protocol CinemaMsgViewDelegate <NSObject>

- (void)jumpToCinemaMsgViewEvent:(CinemaMsgViewEvents)event;

@end
@interface CinemaMsgView : UIView

@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *addressLb;
@property(nonatomic,strong) UIButton *gotoImg;
@property(nonatomic,strong) UIButton *mapImg;
@property(nonatomic,weak) id<CinemaMsgViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame CinemaMsg:(Cinema *)CinemaMsg;

@end
