//
//  RefundView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "RefundView.h"

@interface RefundView ()
{
    UIButton *_maskView;
}
@end
@implementation RefundView

- (instancetype)initWithFrame:(CGRect)frame WithContent:(NSString *)content
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.0f;
        self.layer.masksToBounds = YES;
        UILabel *headerLb = [FanShuToolClass createLabelWithFrame:CGRectMake(23, 20, frame.size.width -46, 17) text:@"尊敬的顾客您好!" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:headerLb];
        self.headerView = headerLb;
        
        CGSize contentSize = [FanShuToolClass createString:content font:[UIFont systemFontOfSize:16] lineSpacing:5 maxSize:CGSizeMake(frame.size.width -46, ScreenHeight)];
        UILabel *contentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(23, 20 +17 +5, frame.size.width -46, contentSize.height) text:content font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        contentLb.numberOfLines = 0;
        [self addSubview:contentLb];
        self.contentView = contentLb;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.firstLineHeadIndent = 35;
        [paraStyle setLineSpacing:7];
        [str addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
        contentLb.attributedText = str;
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(0, frame.size.height -48, frame.size.width, 1) backgroundColor:Color(243, 243, 243, 1.0)];
        [self addSubview:line];
        
        UIView *line1 = [FanShuToolClass createViewWithFrame:CGRectMake(frame.size.width / 2 -1, frame.size.height -47, 1, 47) backgroundColor:Color(243, 243, 243, 1.0)];
        [self addSubview:line1];
        
        NSArray *btns = @[@"取消",@"确定"];
        NSArray *colors = @[[UIColor blackColor],Color(0, 151, 235, 1.0)];
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(frame.size.width / 2 * i, frame.size.height -47, frame.size.width / 2 -1, 47) title:btns[i] titleColor:colors[i] target:self action:@selector(btnDidClicked:) tag:100 +i];
            [self addSubview:btn];
        }
        
        _maskView = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) title:nil titleColor:[UIColor blackColor] target:self action:@selector(hiddenView) tag:1000];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)btnDidClicked:(UIButton *)btn
{
    if (btn.tag == 100) {
        // 取消
        [self hiddenView];
    }else if (btn.tag == 101){
        // 确定
        [self hiddenView];
        if ([self.delegate respondsToSelector:@selector(gotoRefundViewEvents:)]) {
            [self.delegate gotoRefundViewEvents:btn.tag];
        }
    }
}

- (void)hiddenView
{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)show
{
    [self animationWithView:self duration:0.3];
    _maskView.alpha= 0;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.65;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow  addSubview:self];
    self.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
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

@end
