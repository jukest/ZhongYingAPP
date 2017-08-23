//
//  MoviesSliderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MoviesSliderView.h"
#import "HotFilm.h"
#import "UIImageView+WebCache.h"

@interface MoviesSliderView ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@end
@implementation MoviesSliderView

- (instancetype)initWithFrame:(CGRect)frame picArr:(NSArray *)picArr index:(NSInteger)index
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.picArr = picArr;
        self.pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
        self.pageFlowView.backgroundColor = Color(67, 58, 50, 1.0);
        self.pageFlowView.delegate = self;
        self.pageFlowView.dataSource = self;
        self.pageFlowView.minimumPageAlpha = 0.5;
        self.pageFlowView.minimumPageScale = 0.80;
        self.pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        self.pageFlowView.orginPageCount = picArr.count;
        self.pageFlowView.isOpenAutoScroll = NO;
        
        HotFilm *hotFile = self.picArr[index];
        [self.pageFlowView.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,hotFile.cover]] placeholderImage:[UIImage imageNamed:@""]];
        //UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        //[bottomScrollView addSubview:self.pageFlowView];
        [self.pageFlowView reloadData];
        [self addSubview:self.pageFlowView];
        NSString *name = hotFile.name;
        NSString *mark = [NSString stringWithFormat:@"%.1f分",hotFile.stars];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 160, ScreenWidth, 45) text:[NSString stringWithFormat:@"%@ %@",name,mark] font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.nameLb.text];
        NSRange range = [self.nameLb.text rangeOfString:mark];
        [str addAttribute:NSForegroundColorAttributeName value:Color(233, 126, 8, 1.0) range:range];
        self.nameLb.attributedText = str;
    
        [self addSubview:self.nameLb];
        
        UIImageView *selectView = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 15, 10) image:[UIImage imageNamed:@"movie_selected"] tag:233];
        selectView.center = CGPointMake(ScreenWidth / 2, -4);
        [self.nameLb addSubview:selectView];
        
    }
    return self;
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(95, 130);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    [self.pageFlowView scrollToPage:subIndex];
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.picArr.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, 95, 130)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    HotFilm *hotFile = self.picArr[index];
    [bannerView.mainImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,hotFile.cover]] placeholderImage:[UIImage imageNamed:@""]];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
    if ([self.delegate respondsToSelector:@selector(MovieDidChanged:)]) {
        [self.delegate MovieDidChanged:pageNumber];
    }
}

@end
