//
//  CinemaTitleView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/24.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaTitleView.h"

@implementation CinemaTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.leftView = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 150, 30) title:@"关注影院" titleColor:[UIColor blackColor] target:nil action:nil tag:100];
        self.leftView.center = CGPointMake(75, frame.size.height / 2);
        [self.leftView setImage:[UIImage imageNamed:@"left_bar"] forState:UIControlStateNormal];
        [self.leftView setImageEdgeInsets:UIEdgeInsetsMake(8, -80, 8, 0)];
        [self.leftView setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 65)];
        self.leftView.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.leftView];
        
        self.rightView = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 150, 30) title:@"更多影院" titleColor:Color(85, 85, 85, 1.0) target:nil action:nil tag:101];
        [self.rightView setImage:[UIImage imageNamed:@"cinema_back"] forState:UIControlStateNormal];
        [self.rightView setImageEdgeInsets:UIEdgeInsetsMake(8, 132, 8, 0)];
        [self.rightView setTitleEdgeInsets:UIEdgeInsetsMake(8, 20, 8, -20)];

        self.rightView.center = CGPointMake(frame.size.width -75, frame.size.height / 2);
        self.rightView.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.rightView];
    }
    return self;
}

@end
