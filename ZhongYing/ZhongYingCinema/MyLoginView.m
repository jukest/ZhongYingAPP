//
//  MyLoginView.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyLoginView.h"

@implementation MyLoginView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(252, 186, 0, 1.0);
        
        self.myLoginTitleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 300, 40) text:@"欢迎来到中影泰得影院" font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        self.myLoginTitleLb.center = CGPointMake(ScreenWidth/2, 36);
        [self addSubview:self.myLoginTitleLb];
        
        NSArray *btnArr = @[@"登录",@"注册"];
        for (int i=0; i<btnArr.count; i++) {
            UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 100, 36) title:btnArr[i] titleColor:[UIColor whiteColor] target:self action:@selector(myLoginViewClick:) tag:100+i];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 4.0f;
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.borderWidth = 1.0f;
            [self addSubview:btn];
            if (i == 0) {
                btn.center = CGPointMake(ScreenWidth/4, 86);
                self.loginBtn = btn;
            }else {
                self.registerBtn = btn;
                btn.center = CGPointMake(ScreenWidth/2+ScreenWidth/4, 86);
            }
        }
    }
    return self;
}

- (void)myLoginViewClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(MyLoginViewClickWithTag:)]) {
        [self.delegate MyLoginViewClickWithTag:btn.tag];
    }
}

@end
