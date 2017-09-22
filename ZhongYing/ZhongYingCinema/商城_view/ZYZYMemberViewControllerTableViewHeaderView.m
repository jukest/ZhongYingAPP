//
//  ZYZYMemberViewControllerTableViewHeaderView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYZYMemberViewControllerTableViewHeaderView.h"

@interface ZYZYMemberViewControllerTableViewHeaderView ()


/**
 余额label
 */
@property (nonatomic, strong) UILabel *balanceLabel;



/**
 可用积分
 */
@property (nonatomic, strong) UILabel *integralLabel;


/**
 优惠券
 */
@property (nonatomic, strong) UILabel *couponLabel;

@end

@implementation ZYZYMemberViewControllerTableViewHeaderView

- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
//        self.backgroundColor = Color(235, 235, 235, 1);
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
    CGFloat heigth = 15 + 5;
    CGFloat marge = 10;
    CGFloat space = 2;
    NSArray *titles = @[@"余额",@"可用积分",@"优惠券"];
    for (int  i = 0; i < 3; i++) {
        
        CGRect frame = CGRectMake(i * (width + space) , y + marge, width, heigth);
        CGRect frame1 = CGRectMake(i * (width + space), y + marge + heigth, width, heigth);
        
        UILabel *label = [FanShuToolClass createLabelWithFrame:frame text:titles[i] font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        label.backgroundColor = [UIColor whiteColor];
        
        UILabel *label1 = [FanShuToolClass createLabelWithFrame:frame1 text:@"0" font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        label1.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + frame.size.height + marge);
        [self addSubview:btn];
        btn.tag = MyBalanceButtonType + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:btn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(frame), frame.origin.y, 2, btn.frame.size.height - 10)];
        line.backgroundColor = Color(240, 240, 240, 0.7);
        [self addSubview:line];
        
        
        if ([titles[i] isEqualToString:@"余额"]) {
            self.balanceLabel = label1;
        } else if ([titles[i] isEqualToString:@"可用积分"]) {
            self.integralLabel = label1;
        } else if ([titles[i] isEqualToString:@"优惠券"]) {
            self.couponLabel = label1;
        }
        
        
        [self addSubview:label];
        [self addSubview:label1];
        
    }
    
    
}

- (void)setBalanceStr:(NSString *)balanceStr {
    _balanceStr = balanceStr;
    self.balanceLabel.text = balanceStr;
}

- (void)setIntegralStr:(NSString *)integralStr {
    _integralStr = integralStr;
    self.integralLabel.text = integralStr;
}

- (void)setCouponStr:(NSString *)couponStr {
    _couponStr = couponStr;
    self.couponLabel.text = couponStr;
}

- (void)btnAction:(UIButton *)sender {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tableViewHeaderView:didClickButton:type:)]) {
            [self.delegate tableViewHeaderView:self didClickButton:sender type:sender.tag];
        }
    }
    
    switch (sender.tag) {
        case MyBalanceButtonType:
            NSLog(@"余额");
            break;
        case MyIntegralButtonType:
            NSLog(@"可用积分");
            break;
        default:
            NSLog(@"优惠券");
            break;
    }
}


@end
