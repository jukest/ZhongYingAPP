//
//  ZYPaymentViewCtlHeader.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYPaymentViewCtlHeader.h"

@implementation ZYPaymentViewCtlHeader

- (instancetype)initWithFrame:(CGRect)frame packageArr:(NSArray *)packages lastPrice:(NSString *)lastPrice {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *backImgView = [FanShuToolClass createImageViewWithFrame:frame image:[UIImage imageNamed:@"payment_background"] tag:777];
        [self addSubview:backImgView];
        
        CGFloat height = 15;
        UILabel *totalMoney = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 10, self.width, height) text:[NSString stringWithFormat:@"合计:￥%@",lastPrice] font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:totalMoney];
        
        CGFloat y = CGRectGetMaxY(totalMoney.frame) + 10;
        
        for (int i = 0; i < packages.count; i++) {
            NSDictionary *dic = packages[i];
            UILabel *label = [FanShuToolClass createLabelWithFrame:CGRectMake(20, y + i * (height + 10), self.width, height) text:[NSString stringWithFormat:@"%@  ￥%@ x%@",dic[@"name"],dic[@"price"],dic[@"number"]] font:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
            [self addSubview:label];
            
        }
        
        
        
    }
    return self;
}
@end
