//
//  SelectSeatView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/2.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SelectSeatViewEvents){
    ExchangeMovieEvent = 666,
    SelectOneSeatEvent,
    SelectTwoSeatEvent,
    SelectThreeSeatEvent,
    SelectFourSeatEvent,
};

@protocol SelectSeatViewDelegate <NSObject>

- (void)gotoSelectSeatViewEvent:(SelectSeatViewEvents)event;

@end
@interface SelectSeatView : UIView

@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *typeLb;
@property(nonatomic,strong) UIButton *exchangeBtn;
@property(nonatomic,strong) UIButton *oneSeatBtn;
@property(nonatomic,strong) UIButton *twoSeatBtn;
@property(nonatomic,strong) UIButton *threeSeatBtn;
@property(nonatomic,strong) UIButton *fourSeatBtn;
@property(nonatomic,strong) UIView *movieRoomView;

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,weak) id<SelectSeatViewDelegate> delegate;

- (void)configMovieRoomWithDict:(NSDictionary *)dict;

- (void)changeBestSeatViewWith:(NSArray *)seatsArray SeatsCount:(NSInteger)count;

@end
