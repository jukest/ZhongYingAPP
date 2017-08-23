//
//  CinemaComplaintView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/24.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaComplaintView.h"

@interface CinemaComplaintView ()<UITextViewDelegate>
{
    UIButton    *_maskView;
}
@end
@implementation CinemaComplaintView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.closeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(frame.size.width -30, 0, 30, 30) image:[UIImage imageNamed:@"complaint_close"] target:self action:@selector(closeCinemaComplaintView:) tag:100];
        [self addSubview:self.closeBtn];
        
        self.complaintFld = [[UITextView alloc] initWithFrame:CGRectMake(15, 30, frame.size.width -30, 155 * heightFloat)];
        self.complaintFld.layer.borderWidth = 1.0f;
        self.complaintFld.layer.borderColor = Color(238, 238, 238, 1.0).CGColor;
        self.complaintFld.font = [UIFont systemFontOfSize:15 * widthFloat];
        self.complaintFld.returnKeyType = UIReturnKeyDone;
        self.complaintFld.delegate = self;
        [self addSubview:self.complaintFld];
        
        self.noteLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15, 185 * heightFloat, 250 * widthFloat, 50 * heightFloat) text:@"有了您的监督，我们才能更快的成长!" font:[UIFont systemFontOfSize:14 * widthFloat] textColor:[UIColor grayColor] alignment:NSTextAlignmentCenter];
        [self addSubview:self.noteLb];
        
        self.sendBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth - 15 -82 * widthFloat , 190 * heightFloat, 70 * widthFloat, 35 * heightFloat) title:@"发送" titleColor:[UIColor whiteColor] target:self action:@selector(CinemaComplaintViewEvents:) tag:200];
        self.sendBtn.backgroundColor = Color(180, 180, 180, 1.0);
        self.sendBtn.layer.cornerRadius = 5.0f;
        self.sendBtn.layer.masksToBounds = YES;
        self.sendBtn.enabled = NO;
        [self addSubview:self.sendBtn];
        
        _maskView = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -49) title:nil titleColor:[UIColor blackColor] target:self action:@selector(hiddenView) tag:1000];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)closeCinemaComplaintView:(UIButton *)btn
{
    [self hiddenView];
}

- (void)CinemaComplaintViewEvents:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(sendComplaint:)]) {
        [self.delegate sendComplaint:self.complaintFld.text];
    }
}

- (void)show
{
    [self animationWithView:self duration:0.3];
    _maskView.alpha= 0;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.5;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow  addSubview:self];
    self.center = CGPointMake(ScreenWidth / 2, ScreenHeight -120 * heightFloat -49);
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

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] >= 6) {
        self.sendBtn.backgroundColor = Color(252, 186, 0, 1.0);
        self.sendBtn.enabled = YES;
    }else{
        self.sendBtn.backgroundColor = Color(180, 180, 180, 1.0);
        self.sendBtn.enabled = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.center = CGPointMake(ScreenWidth / 2, ScreenHeight -120 * heightFloat -49 -200);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.center = CGPointMake(ScreenWidth / 2, ScreenHeight -120 * heightFloat -49);
    }];
}

@end
