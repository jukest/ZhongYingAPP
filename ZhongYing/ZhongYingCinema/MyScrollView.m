//
//  MyScrollView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/27.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

//重写该方法后可以让超出父视图范围的子视图响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //if内的条件应该为，当触摸点point超出蓝色部分，但在黄色部分时
    if (1){
        return YES;
    }
    return NO;
}

@end
