//
//  InfoDetailsShareView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "InfoDetailsShareView.h"

@interface InfoDetailsShareView ()
{
    UIButton    *_maskView;
}
@end
@implementation InfoDetailsShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 5, 100, 25) text:@"分享到" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLb];
        NSArray *titles = @[@"微信好友",@"朋友圈",@"QQ",@"QQ空间",@"微博"];
        NSArray *shareImg = @[@"wechat_share",@"friend_share",@"qq_share",@"Qzone_share",@"sina_share"];
        CGFloat w = (ScreenWidth -44 -5 * 60) / 4;
        for (int i = 0; i < 5; i ++) {
            UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(22 +i * (60 + w), 25 +10, 60, 70) title:titles[i] titleColor:[UIColor blackColor] target:self action:@selector(shareBtnEvents:) tag:1000+i];
            [btn setImage:[UIImage imageNamed:shareImg[i]] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            CGSize imageSize = btn.imageView.frame.size;
            CGSize titleSize = btn.titleLabel.frame.size;
            
            // get the height they will take up as a unit
            CGFloat totalHeight = (imageSize.height + titleSize.height + 10);
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(- (totalHeight - imageSize.height), (60 -imageSize.width) / 2 , 0.0, 0)];
            switch (i) {
                case 0:
                    self.WFriendShareBtn = btn;
                    break;
                case 1:
                    self.friendCircelShareBtn = btn;
                    break;
                case 2:
                    self.QFriendShareBtn = btn;
                    break;
                case 3:
                    self.QzoneShareBtn = btn;
                    break;
                case 4:
                    self.sinaShareBtn = btn;
                    break;
                default:
                    break;
            }
            [self addSubview:btn];
        }
        _maskView = [FanShuToolClass createButtonWithFrame:[UIScreen mainScreen].bounds title:nil titleColor:[UIColor blackColor] target:self action:@selector(hiddenView) tag:1000];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)show
{
    [self animationWithView:self duration:0.3];
    _maskView.alpha= 0;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.5;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = CGPointMake(ScreenWidth / 2, ScreenHeight -50);
}

- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}

- (void)hiddenView
{   [_maskView removeFromSuperview];
    [self removeFromSuperview];
}


- (void)shareBtnEvents:(UIButton *)btn
{
    [self hiddenView];
    if ([self.delegate respondsToSelector:@selector(jumpToShareView:)]) {
        [self.delegate jumpToShareView:btn.tag];
    }
}

@end
