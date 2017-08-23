//
//  PictureView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/2/16.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithUrlStr:(NSString *)urlStr Sliders:(NSArray *)sliders  Index:(NSInteger)index;

- (void)show;

@end
