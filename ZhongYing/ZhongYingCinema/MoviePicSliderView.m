//
//  MoviePicSliderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MoviePicSliderView.h"
#import "UIImageView+WebCache.h"

@implementation MoviePicSliderView

- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *)picArr
{
    if (self = [self initWithFrame:frame]) {
        NSInteger count = picArr.count; // 图片数量
        CGFloat more = 0;
        if (count > 6) {
            count = 6;
            more = 50;
        }
        
        self.scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 36, ScreenWidth, 100) contentSize:CGSizeMake(12 + 85 * count + 10 * (count -1) + 12 + more, 100) target:self];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 8, 65, 20) text:@"影片图片" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLb];
    
    }
    return self;
}

- (void)configMoviePicSliderViewWithSliders:(NSArray *)sliders
{
    NSInteger count = sliders.count; // 图片数量
    CGFloat more = 0;
    if (count > 6) {
        count = 6;
        more = 50;
    }
    self.scrollView.contentSize = CGSizeMake(12 + 85 * count + 10 * (count -1) + 12 + more, 100);
    for (int i = 0; i < count; i ++) {
        UIImageView *imageView = [FanShuToolClass createImageViewWithFrame:CGRectMake(12 + i * 95, 0, 85, 100) color:[UIColor whiteColor]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [self.scrollView addSubview:imageView];
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,sliders[i]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMoviePicSliderViewEvents:)];
        [imageView addGestureRecognizer:tap];
    }
    if (more != 0) {
        UIButton *moreBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12 + 6 * 95, 0, 40, 100) title:@"更\n\n多" titleColor:[UIColor whiteColor] target:self action:@selector(morePicBtnDidClicked:) tag:MoreMoviePicEvent];
        moreBtn.titleLabel.numberOfLines = 0;
        moreBtn.backgroundColor = Color(252, 186, 0, 1.0);
        [self.scrollView addSubview:moreBtn];
    }
}

- (void)gotoMoviePicSliderViewEvents:(UIGestureRecognizer *)tap
{
    NSLog(@"点击图片");
    if ([self.delegate respondsToSelector:@selector(jumpToPictureClickEvent:)]) {
        [self.delegate jumpToPictureClickEvent:tap.view.tag];
    }
}

- (void)morePicBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(jumpToMoviePicSliderViewEvents:)]) {
        [self.delegate jumpToMoviePicSliderViewEvents:btn.tag];
    }
}

@end
