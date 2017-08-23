//
//  TipView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/3/8.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "TipView.h"

@interface TipView ()<UITextViewDelegate>
{
    UIButton *_maskView;
}
@end
@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.closeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(frame.size.width -30, 0, 30, 30) image:[UIImage imageNamed:@"complaint_close"] target:self action:@selector(closeCinemaComplaintView:) tag:100];
        [self addSubview:self.closeBtn];
        
        NSArray *arr = @[@"距离开场30分钟",@"生化危机：终章",@"今天3月8日 14:00-16:09 (英语3D)",@"星河(环星)影城 3号厅",@"5排4座 5排5座",@"2017030715121234"];
        for (NSInteger i = 0; i < 6; i ++) {
            UILabel *lb = [FanShuToolClass createLabelWithFrame:CGRectMake(15, 15 + i * (20 +5), frame.size.width, 20) text:arr[i] font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
            [self addSubview:lb];
            switch (i) {
                case 0:
                    self.remainTimeLb = lb;
                    break;
                case 1:
                    self.nameLb = lb;
                    self.nameLb.font = [UIFont systemFontOfSize:17 * widthFloat];
                    break;
                case 2:
                    self.releaseDateLb = lb;
                    break;
                case 3:
                    self.cinemaNameLb = lb;
                    break;
                case 4:
                    self.seatsLb = lb;
                    break;
                case 5:
                    self.codeLb = lb;
                    self.codeLb.font = [UIFont systemFontOfSize:17 * widthFloat];
                    break;
                default:
                    break;
            }
        }
        self.codeImg = [FanShuToolClass createImageViewWithFrame:CGRectMake((frame.size.width -220) / 2, 160, 220, 220) image:[UIImage imageNamed:@""] tag:212];
        [self addSubview:self.codeImg];
        
        _maskView = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) title:nil titleColor:[UIColor blackColor] target:self action:@selector(hiddenView) tag:1000];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - Help Methods
- (void)closeCinemaComplaintView:(UIButton *)btn
{
    [self hiddenView];
}

- (void)show
{
    [self animationWithView:self duration:0.3];
    _maskView.alpha= 0;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.5;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow  addSubview:self];
    self.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
}

- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}

- (void)hiddenView
{   [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)configTipView:(NSDictionary *)dict
{
    int start = [dict[@"start_time"] intValue];
    int current = (int)[[NSDate date] timeIntervalSince1970];
    int sec = (start -current) / 60;
    if (sec != 0) {
        self.remainTimeLb.text = [NSString stringWithFormat:@"距离开场%d分钟",sec];
    }else{
        self.remainTimeLb.text = @"影片已开场";
    }
    self.remainTimeLb.textColor = [UIColor redColor];
    self.nameLb.text = dict[@"name"];
    NSString *date = [[NSString stringWithFormat:@"%d",start] transforTomyyyyMMddWithFormatter:@"MM-dd"];
    NSString *startTime = [[NSString stringWithFormat:@"%d",start] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    NSString *endTime = [[NSString stringWithFormat:@"%@",dict[@"end_time"]] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    self.releaseDateLb.text = [NSString stringWithFormat:@"今天%@ %@-%@",date,startTime,endTime];
    self.releaseDateLb.textColor = [UIColor redColor];
    self.cinemaNameLb.text = [NSString stringWithFormat:@"%@ %@",dict[@"cinema_name"],dict[@"hall_name"]];
    NSMutableArray *seatsArr = [NSMutableArray array];
    for (NSDictionary *seat in dict[@"seat"]) {
        [seatsArr addObject:[NSString stringWithFormat:@"%@排%@座",seat[@"row"],seat[@"column"]]];
    }
    self.seatsLb.text = [seatsArr componentsJoinedByString:@" "];
    self.codeLb.text = [NSString stringWithFormat:@"取票码：%@",dict[@"ticket_code"]];
    [self.codeImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageDetail_URL,dict[@"qrcode"]]] placeholderImage:[UIImage imageNamed:@""]];
}

@end
