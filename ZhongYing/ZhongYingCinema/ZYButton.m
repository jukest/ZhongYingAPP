//
//  ZYButton.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYButton.h"

@implementation ZYButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = 0;

    if (self.width < ScreenWidth / 4) {
        width = 20;
    } else {
        width = 40;
    }
    
    CGFloat x = (self.width - width) * 0.5;
    CGFloat y = 10;
    self.imageView.frame = CGRectMake(x, y, width, width);
    self.imageView.backgroundColor = [UIColor clearColor];
    
    CGFloat width1 = self.width - (5 * 2);
    y = y + width ;
    x = 5;
    self.titleLabel.frame = CGRectMake(x, y, width1, self.height - y);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}


@end
