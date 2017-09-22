//
//  informationSliderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "informationSliderView.h"

@implementation informationSliderView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 轮播图
        self.adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.adView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        
        
        self.adView.currentPageDotColor = Color(252, 186, 0, 1.0); // [UIColor redColor];// 自定义分页控件小圆标颜色
        self.adView.pageDotColor = [UIColor whiteColor];
        //self.adView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.adView];
        
        // 资讯父视图
//        UIView *infoBottomView = [FanShuToolClass createViewWithFrame:CGRectMake(0, frame.size.height / 4 * 3, frame.size.width, frame.size.height / 4) backgroundColor:[UIColor whiteColor]];
//        [self addSubview:infoBottomView];
        
//        //  新闻资讯
//        self.newsInfoBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(10, 0, ScreenWidth / 3 -20, frame.size.height / 4) title:@"新闻资讯" titleColor:[UIColor blackColor] target:self action:@selector(infoSliderViewEvents:) tag:NewsInfoEvent];
//        self.newsInfoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.newsInfoBtn setImage:[UIImage imageNamed:@"info_news"] forState:UIControlStateNormal];
//        [self.newsInfoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        [infoBottomView addSubview:self.newsInfoBtn];
//        
//        //  影片资讯
//        self.movieInfoBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth / 3 +10, 0, ScreenWidth / 3 -20, frame.size.height / 4) title:@"影片资讯" titleColor:[UIColor blackColor] target:self action:@selector(infoSliderViewEvents:) tag:MovieInfoEvent];
//        self.movieInfoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.movieInfoBtn setImage:[UIImage imageNamed:@"info_movie"] forState:UIControlStateNormal];
//        [self.movieInfoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        [infoBottomView addSubview:self.movieInfoBtn];
//        
//        //  票房
//        self.boxOfficeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth / 3 * 2 + 10, 0, ScreenWidth / 3 -20, frame.size.height / 4) title:@"票房" titleColor:[UIColor blackColor] target:self action:@selector(infoSliderViewEvents:) tag:BoxOfficeEvnet];
//        self.boxOfficeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.boxOfficeBtn setImage:[UIImage imageNamed:@"info_boxoffice"] forState:UIControlStateNormal];
//        [self.boxOfficeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        [infoBottomView addSubview:self.boxOfficeBtn];
//        
//        for (int i = 0; i < 2; i ++) {
//            UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(ScreenWidth / 3 * (i +1), 10, 1, infoBottomView.frame.size.height - 20) backgroundColor:Color(236, 236, 236, 1.0)];
//            [infoBottomView addSubview:line];
//        }
    }
    return self;
}

- (void)configCellWithArray:(NSMutableArray *)picArr{
    
    self.adView.imageURLStringsGroup = picArr;
    
}

#pragma mark - Views Handle
- (void)infoSliderViewEvents:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(infoSliderViewDelegateWithTag:)]) {
        [self.delegate infoSliderViewDelegateWithTag:btn.tag];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
}

@end
