//
//  MovieDetailsHeaderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieMessageView.h"
#import "MoviePicSliderView.h"
#import "MovieBoxOfficeView.h"
#import "MovePictureSliderView.h"

@interface MovieDetailsHeaderView : UIView

@property(nonatomic,strong) MovieMessageView *movieMessage;
@property(nonatomic,strong) MoviePicSliderView *moviePicSlider;
@property(nonatomic,strong) MovieBoxOfficeView *movieBoxOffice;
@property(nonatomic,strong) MovePictureSliderView *pictureSliderView;

- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *)picArr Film:(HotFilm *)film type:(NSString *)type;


@end
