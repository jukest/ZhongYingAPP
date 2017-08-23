//
//  MovePictureSliderView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAdView.h"


typedef NS_ENUM(NSInteger,MovePictureSliderViewEvents){
    MMovePictureSliderViewClickEvent = 222,
    
};

@protocol MovePictureSliderViewDelegate <NSObject>


- (void)jumpToPictureClickEvent:(NSInteger)index;

@end


@interface MovePictureSliderView : UIView

@property(nonatomic,strong) SCAdView *adView;


@property(nonatomic,weak) id<MovePictureSliderViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *)picArr;

- (void)configMoviePicSliderViewWithSliders:(NSArray *)sliders;


@end
