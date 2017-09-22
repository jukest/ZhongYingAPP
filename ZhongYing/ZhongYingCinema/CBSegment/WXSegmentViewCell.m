//
//  WXSegmentViewCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/19.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "WXSegmentViewCell.h"

@interface WXSegmentViewCell ()

@end

@implementation WXSegmentViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 5)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"周六9月25日";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    [backgroundView addSubview:label];
    self.label = label;
    
    UIView *slider = [[UIView alloc]init];
    slider.frame = CGRectMake(5, self.height - 6, self.width - 10, 2);
    slider.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:slider];
    self.line = slider;
    self.backgroundView = backgroundView;
    
    UIView *selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.selectedBackgroundView = selectedBackgroundView;
    
    
    UILabel *selectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 5)];
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.text = @"周六9月25日";
    selectedLabel.font = [UIFont systemFontOfSize:14];
    selectedLabel.textColor = [UIColor redColor];
    [selectedBackgroundView addSubview:selectedLabel];
    self.selectedLabel = selectedLabel;
    
    UIView *selectedSlider = [[UIView alloc]init];
    selectedSlider.frame = CGRectMake(5, self.height - 6, self.width - 10, 2);
    selectedSlider.backgroundColor = [UIColor redColor];
    [selectedBackgroundView addSubview:selectedSlider];
    self.selectedLine = selectedSlider;
    
}





@end
