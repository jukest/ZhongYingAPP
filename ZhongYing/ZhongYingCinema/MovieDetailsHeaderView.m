//
//  MovieDetailsHeaderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieDetailsHeaderView.h"
#import "HotFilm.h"

@implementation MovieDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *)picArr Film:(HotFilm *)film type:(NSString *)type
{
    if (self = [self initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.movieMessage = [[MovieMessageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 352 +frame.size.height -610) film:film type:type];
        [self addSubview:self.movieMessage];
        
        UIView *view1 = [FanShuToolClass createViewWithFrame:CGRectMake(0, self.movieMessage.frame.size.height, ScreenWidth, 10) backgroundColor:Color(239, 239, 239, 1.0)];
        [self addSubview:view1];
        
        UIView *view2;
        if (picArr.count != 0) {
            
            self.pictureSliderView = [[MovePictureSliderView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y +10, ScreenWidth, 144) pictures:picArr];
            
            /**
            self.moviePicSlider = [[MoviePicSliderView alloc] initWithFrame:CGRectMake(0, view1.frame.origin.y +10, ScreenWidth, 144) pictures:picArr];*/
            view2 = [FanShuToolClass createViewWithFrame:CGRectMake(0, self.pictureSliderView.frame.origin.y +144, ScreenWidth, 10) backgroundColor:Color(239, 239, 239, 1.0)];
            self.movieBoxOffice = [[MovieBoxOfficeView alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y +10, ScreenWidth, 84)];
        }else{
            
            self.pictureSliderView = [[MovePictureSliderView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y +10, ScreenWidth, 0) pictures:picArr];
            /**
            self.moviePicSlider = [[MoviePicSliderView alloc] initWithFrame:CGRectMake(0, view1.frame.origin.y +10, ScreenWidth, 0) pictures:picArr];*/
            view2 = [FanShuToolClass createViewWithFrame:CGRectMake(0, self.pictureSliderView.frame.origin.y, ScreenWidth, 0) backgroundColor:Color(239, 239, 239, 1.0)];
            self.movieBoxOffice = [[MovieBoxOfficeView alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y, ScreenWidth, 84)];
        }
        [self addSubview:self.pictureSliderView];
        [self addSubview:view2];
        [self addSubview:self.movieBoxOffice];
        
        UIView *view3 = [FanShuToolClass createViewWithFrame:CGRectMake(0, self.movieBoxOffice.frame.origin.y +84, ScreenWidth, 10) backgroundColor:Color(239, 239, 239, 1.0)];
        [self addSubview:view3];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color(239, 239, 239, 1.0);
        
    }
    return self;
}

@end
