//
//  CinemaMsgView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaMsgView.h"

@implementation CinemaMsgView

- (instancetype)initWithFrame:(CGRect)frame CinemaMsg:(Cinema *)CinemaMsg;
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15, 250, 20) text:CinemaMsg.title font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.nameLb];
        
        self.addressLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 38, ScreenWidth -90 -12, 15) text:CinemaMsg.address font:[UIFont systemFontOfSize:15] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
        [self addSubview:self.addressLb];

        self.gotoImg = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -90, 0, 25, 66) image:[UIImage imageNamed:@"cinema_back"] target:self action:@selector(gotoCinemaDtlHeaderViewEvents:) tag:CinemaDetailsEvent];
        [self.gotoImg setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [self addSubview:self.gotoImg];
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(ScreenWidth -90 +10 +15, 5, 1, 56) backgroundColor:Color(180, 180, 180, 233)];
        [self addSubview:line];
        
        UIView *view = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, ScreenWidth -90 +10 +15, 66) color:[UIColor clearColor]];
        view.userInteractionEnabled = YES;
        [self addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCinemaMessageViewCtl:)];
        [view addGestureRecognizer:tap];
        
        self.mapImg = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -90 +10 +15, 0, 65, 66) title:@"地图" titleColor:Color(80, 80, 80, 1.0) target:self action:@selector(gotoCinemaDtlHeaderViewEvents:) tag:CinemaMapEvent];
        self.mapImg.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.mapImg setImage:[UIImage imageNamed:@"cinema_address"] forState:UIControlStateNormal];
        CGSize imageSize = self.mapImg.imageView.frame.size;
        CGSize titleSize = self.mapImg.titleLabel.frame.size;
        // get the height they will take up as a unit
        CGFloat totalHeight = (imageSize.height + titleSize.height + 10);
        [self.mapImg setImageEdgeInsets:UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width)];
        [self.mapImg setTitleEdgeInsets:UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0)];
        
        [self addSubview:self.mapImg];
    }
    return self;
}

- (void)gotoCinemaDtlHeaderViewEvents:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(jumpToCinemaMsgViewEvent:)]) {
        [self.delegate jumpToCinemaMsgViewEvent:btn.tag];
    }
}

- (void)gotoCinemaMessageViewCtl:(UIGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(jumpToCinemaMsgViewEvent:)]) {
        [self.delegate jumpToCinemaMsgViewEvent:CinemaDetailsEvent];
    }
}

@end
