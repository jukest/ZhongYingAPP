//
//  CinemaSliderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/24.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaSliderView.h"

@implementation CinemaSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = Color(234, 234, 234, 1.0);
        // 轮播图
        self.adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        //cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        self.adView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //cycleScrollView2.titlesGroup = titles;
        self.adView.currentPageDotColor = [UIColor grayColor]; // 自定义分页控件小圆标颜色
        self.adView.pageDotColor = [UIColor whiteColor];
        //self.adView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        //self.adView.imageURLStringsGroup = imagesURLStrings;
        [self addSubview:self.adView];
        
       /** // 影院信息视图
        UIView *cinemaMsgView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 150, frame.size.width, 85) backgroundColor:[UIColor whiteColor]];
        [self addSubview:cinemaMsgView];
        
        //  更多影院
        self.titleView = [[CinemaTitleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.titleView.rightView.tag = MoreCinemaEvent;
        [self.titleView.rightView addTarget:self action:@selector(moreCinemaEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cinemaMsgView addSubview:self.titleView];
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(20, 30, frame.size.width - 30, 1) backgroundColor:Color(232, 232, 232, 1.0)];
        [cinemaMsgView addSubview:line];
        
        // 影院信息
        UIView *cinemaView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 31, frame.size.width, 85 -31) backgroundColor:[UIColor whiteColor]];
        cinemaView.tag = CinemaMessageEvent;
        [cinemaMsgView addSubview:cinemaView];
        self.cinemaNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 10, 300, 15) text:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [cinemaView addSubview:self.cinemaNameLb];
        self.cinemaAddressLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 33, 300, 10) text:@"" font:[UIFont systemFontOfSize:13]  textColor:Color(84, 84, 84, 1.0) alignment:NSTextAlignmentLeft];
        [cinemaView addSubview:self.cinemaAddressLb];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cinemaMessageEvent:)];
        [cinemaView addGestureRecognizer:tap];
        */
    }
    return self;
}

- (void)configCellWithArray:(NSMutableArray *)picArr cinemaMsg:(Cinema *)cinemaMsg
{
    self.adView.imageURLStringsGroup = picArr;
    self.cinemaNameLb.text = cinemaMsg.title;
    self.cinemaAddressLb.text = cinemaMsg.address;
}
#pragma mark - Views Handle
- (void)cinemaMessageEvent:(UIGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(gotoCinemaSliderEventsWithTag:)]) {
        [self.delegate gotoCinemaSliderEventsWithTag:tap.view.tag];
    }
}

- (void)moreCinemaEvent:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoCinemaSliderEventsWithTag:)]) {
        [self.delegate gotoCinemaSliderEventsWithTag:btn.tag];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
}

@end
