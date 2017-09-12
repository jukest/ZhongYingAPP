//
//  ZYZYMemberViewControllerTableViewHeaderView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYZYMemberViewControllerTableViewHeaderView.h"

@implementation ZYZYMemberViewControllerTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    UIImageView *imgView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mall_member"]];
    imgView.frame = CGRectMake(10, 20, ScreenWidth - 20, 200);
    [self addSubview:imgView];
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    
    CGFloat y = CGRectGetMaxY(imgView.frame);
    CGFloat width = self.width / 3;
    CGFloat heigth = 15;
    CGFloat marge = 10;
    NSArray *titles = @[@"余额",@"可用积分",@"优惠券"];
    for (int  i = 0; i < 3; i++) {
        CGRect frame = CGRectMake(i * width , y + marge, width, heigth);
        CGRect frame1 = CGRectMake(i * width, y + marge + marge + heigth, width, heigth);
        
        UILabel *label = [FanShuToolClass createLabelWithFrame:frame text:titles[i] font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        
        UILabel *label1 = [FanShuToolClass createLabelWithFrame:frame1 text:@"0" font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        
        [self addSubview:label];
        [self addSubview:label1];
        
    }
    
    
}



@end
