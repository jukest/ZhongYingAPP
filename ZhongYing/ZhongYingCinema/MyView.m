//
//  MyView.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/16.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(252, 186, 0, 1.0);
        
        self.myHeadImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 86, 86) image:[UIImage imageNamed:@""] tag:1000];
        [self.myHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,ApiavatarStr]] placeholderImage:[UIImage imageNamed:@"my_head"]];
        self.myHeadImg.center = CGPointMake(ScreenWidth/2, 66);
        self.myHeadImg.layer.cornerRadius = CGRectGetWidth(self.myHeadImg.frame)/2;
        self.myHeadImg.layer.masksToBounds = YES;
        [self addSubview:self.myHeadImg];
        
        UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick)];
        [self.myHeadImg addGestureRecognizer:headTap];
        
        self.myUsernameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 200, 30) text:ApiNickNameStr ? ApiNickNameStr : ApimobileStr font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        self.myUsernameLb.center = CGPointMake(ScreenWidth/2, 136);
        [self addSubview:self.myUsernameLb];
        
        //self.myBalanceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 150, ScreenWidth/2-20, 30) text:@"余额：¥50" font:[UIFont systemFontOfSize:17] textColor:[UIColor whiteColor] alignment:NSTextAlignmentRight];
        NSString *balance = @"余额：¥0.00";
        if (ApiMyRemainStr) {
            balance = [NSString stringWithFormat:@"余额：¥%.2f",[ApiMyRemainStr floatValue]];
        }
        self.myBalanceLb = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 150, ScreenWidth/2-20, 30) title:balance titleColor:[UIColor whiteColor] target:nil action:nil tag:90];
        self.myBalanceLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.myBalanceLb setImage:[UIImage imageNamed:@"my_balance"] forState:UIControlStateNormal];
        [self.myBalanceLb setImageEdgeInsets:UIEdgeInsetsMake(0, -5 +25, 0, -25)];
        [self.myBalanceLb setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -25)];
        [self addSubview:self.myBalanceLb];
        
        //self.myIntegralLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth/2+20, 150, ScreenWidth/2-20, 30) text:@"积分：50分" font:[UIFont systemFontOfSize:17] textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        NSString *integral = @"积分：0分";
        if (ApiMyScoreStr) {
            integral = [NSString stringWithFormat:@"积分：%@分",ApiMyScoreStr];
        }
        self.myIntegralLb = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth/2+20, 150, ScreenWidth/2-20, 30) title:integral titleColor:[UIColor whiteColor] target:nil action:nil tag:91];
        self.myIntegralLb.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.myIntegralLb setImage:[UIImage imageNamed:@"my_integral"] forState:UIControlStateNormal];
        [self.myIntegralLb setImageEdgeInsets:UIEdgeInsetsMake(0, -5 -15, 0, 15)];
        [self.myIntegralLb setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        [self addSubview:self.myIntegralLb];
        
        self.myRechargeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 100, 36) title:@"充值" titleColor:[UIColor whiteColor] target:self action:@selector(myViewClick:) tag:100];
        self.myRechargeBtn.center = CGPointMake(ScreenWidth/2, 200);
        self.myRechargeBtn.layer.masksToBounds = YES;
        self.myRechargeBtn.layer.cornerRadius = 4.0f;
        self.myRechargeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.myRechargeBtn.layer.borderWidth = 1.0f;
        [self addSubview:self.myRechargeBtn];
        
        UIView *myBottomView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 230, ScreenWidth, 50) backgroundColor:[UIColor whiteColor]];
        [self addSubview:myBottomView];
        
        self.myOrderBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(20, 0, ScreenWidth/2-40, 50) title:@"我的订单" titleColor:[UIColor blackColor] target:self action:@selector(myViewClick:) tag:101];
        self.myOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.myOrderBtn setImage:[UIImage imageNamed:@"my_order"] forState:UIControlStateNormal];
        [self.myOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [myBottomView addSubview:self.myOrderBtn];
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(ScreenWidth / 2, 5, 1, 40) backgroundColor:Color(236, 236, 236, 1.0)];
        [myBottomView addSubview:line];
        
        NSString *evaluate = @"待评价（0）";
        if (ApiMyCommentStr) {
            evaluate = [NSString stringWithFormat:@"待评价（%@）",ApiMyCommentStr];
        }
        self.myEvaluateBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(20+ScreenWidth/2, 0, ScreenWidth/2-40, 50) title:evaluate titleColor:[UIColor blackColor] target:self action:@selector(myViewClick:) tag:102];
        self.myEvaluateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.myEvaluateBtn setImage:[UIImage imageNamed:@"my_not_evaluate"] forState:UIControlStateNormal];
        [self.myEvaluateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [myBottomView addSubview:self.myEvaluateBtn];
    }
    return self;
}

- (void)myViewClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(MyViewDelegateWithTag:)]) {
        [self.delegate MyViewDelegateWithTag:btn.tag];
    }
}

- (void)headTapClick{
    if ([self.delegate respondsToSelector:@selector(MyViewDelegateClickHead)]) {
        [self.delegate MyViewDelegateClickHead];
    }
}

- (void)configMyViewWithContent:(NSDictionary *)content
{
    [self.myBalanceLb setTitle:[NSString stringWithFormat:@"余额：¥%.2f",[content[@"balance"][@"remain"] floatValue]] forState:UIControlStateNormal];
    [self.myIntegralLb setTitle:[NSString stringWithFormat:@"积分：%@分",content[@"balance"][@"score"]] forState:UIControlStateNormal];
    [self.myEvaluateBtn setTitle:[NSString stringWithFormat:@"待评价（%@）",content[@"comment"]] forState:UIControlStateNormal];
    [self.myHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,ApiavatarStr]] placeholderImage:[UIImage imageNamed:@"my_head"]];
    self.myUsernameLb.text = ApiNickNameStr ? ApiNickNameStr : ApimobileStr;
}

@end
