//
//  MoviePicSliderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MoviePicSliderViewEvents){
   MoviePicClickEvent = 222,
   MoreMoviePicEvent,
};
@protocol MoviePicSliderViewDelegate <NSObject>

- (void)jumpToMoviePicSliderViewEvents:(MoviePicSliderViewEvents)event;

- (void)jumpToPictureClickEvent:(NSInteger)index;

@end
@interface MoviePicSliderView : UIView

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *moreBtn;
@property(nonatomic,weak) id<MoviePicSliderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *)picArr;

- (void)configMoviePicSliderViewWithSliders:(NSArray *)sliders;

@end
