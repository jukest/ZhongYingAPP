


//
//  CinemaMsgFooterView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaMsgFooterView.h"

@implementation CinemaMsgFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color(245, 245, 245, 1.0);
        
        UIView *bottomView = [FanShuToolClass createViewWithFrame:CGRectMake(15, frame.size.height -15 -50, frame.size.width -30, 50) backgroundColor:Color(63, 63, 63, 1.0)];
        bottomView.layer.cornerRadius = 5.0f;
        bottomView.layer.masksToBounds = YES;
        [self addSubview:bottomView];
        
        self.concernBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, (frame.size.width -30) / 2, 50) title:@"关注" titleColor:[UIColor whiteColor] target:self action:@selector(gotoCinemaMsgFooterViewEvents:) tag:CinemaMsgConcernEvent];
        self.concernBtn.center = CGPointMake(bottomView.frame.size.width / 4, 25);
        self.concernBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.concernBtn setImage:[UIImage imageNamed:@"cinema_not_concern"] forState:UIControlStateNormal];
        [self.concernBtn setImage:[UIImage imageNamed:@"cinema_concern"] forState:UIControlStateSelected];
        [self.concernBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [self.concernBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        self.concernBtn.selected = NO;
        [bottomView addSubview:self.concernBtn];
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, 1, 50) backgroundColor:Color(121, 121, 121, 1.0)];
        line.center = CGPointMake(bottomView.frame.size.width / 2, 25);
        [bottomView addSubview:line];
        
        self.commentBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, (frame.size.width -30) / 2, 50) title:@"我要评论" titleColor:[UIColor whiteColor] target:self action:@selector(gotoCinemaMsgFooterViewEvents:) tag:CinemaMsgCommentEvent];
        self.commentBtn.center = CGPointMake(bottomView.frame.size.width / 4 * 3, 25);
        self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.commentBtn setImage:[UIImage imageNamed:@"cinema_comment"] forState:UIControlStateNormal];
        [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [bottomView addSubview:self.commentBtn];
    }
    return self;
}

- (void)gotoCinemaMsgFooterViewEvents:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(jumpToCinemaMsgFooterViewEvents:)]) {
        [self.delegate jumpToCinemaMsgFooterViewEvents:btn.tag];
    }
}

- (void)configViewWithIs_star:(BOOL)is_star
{
    if (is_star) {
        self.concernBtn.selected = YES;
    }else{
        self.concernBtn.selected = NO;
    }
}

@end
