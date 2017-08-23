//
//  ZFSeatButton.m
//
//
//  Created by qq 316917975   on 16/1/27.
//  Copyright © 2016年 qq 316917975 . All rights reserved.
//

#import "ZFSeatButton.h"
#import "UIView+Extension.h"
#import "ZFSeatSelectionConfig.h"

@interface ZFSeatButton ()
{
    UILabel *_lb;
}
@end
@implementation ZFSeatButton
-(void)setHighlighted:(BOOL)highlighted{}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnScale = ZFSeatBtnScale;
    CGFloat btnX = (self.width - self.width * btnScale) * 0.5;
    CGFloat btnY = (self.height - self.height * btnScale) * 0.5;
    CGFloat btnW = self.width * btnScale;
    CGFloat btnH = self.height * btnScale;
    CGFloat centX = self.center.x;
    CGFloat centY = self.center.y;
    self.center = CGPointMake(ceil(centX), ceil(centY));
    self.imageView.frame = CGRectMake(btnX, btnY, btnW, btnH);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

}

@end
