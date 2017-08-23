//
//  BoxOfficeHeaderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "BoxOfficeHeaderView.h"

@interface BoxOfficeHeaderView ()
{
    UILabel *_firstTitle;
    UILabel *_secondTitle;
    UILabel *_thirdTitle;
}
@end

@implementation BoxOfficeHeaderView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [self initWithFrame:frame];
    
    _firstTitle.text = titles[0];
    _secondTitle.text = titles[1];
    _thirdTitle.text = titles[2];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color(247, 89, 110, 1.0);
        _firstTitle = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, ScreenWidth / 3, frame.size.height) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        //_firstTitle.center = CGPointMake((ScreenWidth / 2 -5) / 2, frame.size.height / 2);
        _firstTitle.numberOfLines = 0;
        [self addSubview:_firstTitle];
        
        _secondTitle = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth / 3, 0, (ScreenWidth / 3), frame.size.height) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        //_secondTitle.center = CGPointMake(ScreenWidth / 2 -5 +20, frame.size.height / 2);
        _secondTitle.numberOfLines = 0;
        [self addSubview:_secondTitle];
        
        _thirdTitle = [FanShuToolClass createLabelWithFrame:CGRectMake((ScreenWidth / 3) * 2, 0, (ScreenWidth / 3), frame.size.height) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
       // _thirdTitle.center = CGPointMake(ScreenWidth / 6 * 5, frame.size.height / 2);
        _thirdTitle.numberOfLines = 0;
        [self addSubview:_thirdTitle];
        
    }
    return self;
}

@end
