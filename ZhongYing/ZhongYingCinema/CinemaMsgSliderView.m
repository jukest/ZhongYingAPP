//
//  CinemaMsgSliderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaMsgSliderView.h"

@implementation CinemaMsgSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 轮播图
        self.adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, frame.size.width, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        //cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        self.adView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //cycleScrollView2.titlesGroup = titles;
        self.adView.currentPageDotColor = [UIColor grayColor]; // 自定义分页控件小圆标颜色
        self.adView.pageDotColor = [UIColor whiteColor];
        //self.adView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.adView];
        
        UIView *bottomView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 150, frame.size.width, 50) backgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cinemaViewDidClicked:)];
        [bottomView addGestureRecognizer:tap];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 0, frame.size.width -12,  50) text:@"" font:[UIFont systemFontOfSize:18] textColor:Color(51, 51, 51, 1.0) alignment:NSTextAlignmentLeft];
        self.nameLb.userInteractionEnabled = NO;
        [bottomView addSubview:self.nameLb];
        
        UIImageView *gotoImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 12, 16) image:[UIImage imageNamed:@"cinema_back"] tag:101];
        gotoImg.userInteractionEnabled = NO;
        gotoImg.contentMode = UIViewContentModeScaleAspectFit;
        [bottomView addSubview:gotoImg];
        gotoImg.center = CGPointMake(ScreenWidth -30 +6, 25);
    }
    return self;
}

- (void)configCellWithArray:(NSMutableArray *)picArr CinemaName:(NSString *)name
{
    self.adView.imageURLStringsGroup = picArr;
    self.nameLb.text = name;
}

#pragma mark - View Handle
- (void)cinemaViewDidClicked:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(gotoChangeCinemaEvent)]) {
        [self.delegate gotoChangeCinemaEvent];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);

}

@end
