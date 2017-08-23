//
//  SelectSeatView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/2.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "SelectSeatView.h"
#import "ZFSeatsModel.h"
#import "ZFSeatModel.h"
#import "ZFSeatSelectionView.h"
#import "ZFSeatButton.h"

@interface SelectSeatView ()
{
    UIView *_bestView;
}
@end
@implementation SelectSeatView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *seatStatusView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 38) backgroundColor:[UIColor whiteColor]];
        [self addSubview:seatStatusView];
        
        NSArray *status = @[@"可选",@"已售",@"已选"];
        NSArray *seatImg = @[@"choosable",@"sold",@"selected"];
        for (int i = 0; i < 3; i ++) {
            UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth / 2 -107 + i * 79, 9, 56, 20) title:status[i] titleColor:Color(45, 45, 45, 1.0) target:nil action:nil tag:100];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
            [btn setImage:[UIImage imageNamed:seatImg[i]] forState:UIControlStateNormal];
            
            [seatStatusView addSubview:btn];
        }
        
        //具体选票座位视图
        self.movieRoomView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 38, ScreenWidth, 232) backgroundColor:[UIColor lightGrayColor]];
        [self addSubview:self.movieRoomView];
        
        //电影信息
        UIView *movieDetails = [FanShuToolClass createViewWithFrame:CGRectMake(0, 270, ScreenWidth, 70) backgroundColor:[UIColor whiteColor]];
        [self addSubview:movieDetails];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 10, 250, 20) text:@"机械师2:复活" font:[UIFont systemFontOfSize:17] textColor:Color(30, 30, 30, 1.0) alignment:NSTextAlignmentLeft];
        [movieDetails addSubview:self.nameLb];
        
        NSString *date = @"今天10月28日";
        CGSize dateSize = [date sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 40, dateSize.width, 15) text:date font:[UIFont systemFontOfSize:14] textColor:Color(30, 30, 30, 1.0) alignment:NSTextAlignmentLeft];
        [movieDetails addSubview:self.dateLb];
        
        NSString *time = @"15:10";
        CGSize timeSize = [time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +dateSize.width +8, 40, timeSize.width +3, 15) text:time font:[UIFont systemFontOfSize:14] textColor:Color(30, 30, 30, 1.0) alignment:NSTextAlignmentLeft];
        [movieDetails addSubview:self.timeLb];
        
        NSString *type = @"英语4D";
        CGSize typeSize = [type sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.typeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +dateSize.width +8 +timeSize.width +3 +8, 40, typeSize.width +10, 15) text:type font:[UIFont systemFontOfSize:14] textColor:Color(30, 30, 30, 1.0) alignment:NSTextAlignmentLeft];
        [movieDetails addSubview:self.typeLb];
        
        self.exchangeBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -16 -70, 20, 70, 30) title:@"换一场" titleColor:Color(30, 30, 30, 1.0) target:self action:@selector(SelectSeatViewEvents:) tag:ExchangeMovieEvent];
        self.exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.exchangeBtn.layer.cornerRadius = 12.5;
        self.exchangeBtn.layer.masksToBounds = YES;
        self.exchangeBtn.layer.borderWidth = 1.0;
        self.exchangeBtn.layer.borderColor = Color(235, 235, 235, 1.0).CGColor;
        [movieDetails addSubview:self.exchangeBtn];
        
        //分割线
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(15, 340, ScreenWidth -30, 1) backgroundColor:Color(246, 246, 246, 1.0)];
        [self addSubview:line];
        
        
        //最佳推荐
        UIView *bestSeatView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 341, ScreenWidth, 77) backgroundColor:[UIColor whiteColor]];
        [self addSubview:bestSeatView];
        _bestView = bestSeatView;
        
        UILabel *bestLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 10, 80, 15) text:@"最佳推荐" font:[UIFont systemFontOfSize:16] textColor:Color(45, 45, 45, 1.0) alignment:NSTextAlignmentLeft];
        _titleLb = bestLb;
        [bestSeatView addSubview:bestLb];
        
        //CGFloat space = (ScreenWidth -24 -240) / 3;
        CGFloat width = (ScreenWidth -24 -30) / 4;
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(12 + i * (width + 10), 35, width, 30) title:[NSString stringWithFormat:@"%zd座",i+1] titleColor:Color(50, 50, 50, 1.0) target:self action:@selector(SelectSeatViewEvents:) tag:667 +i];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            btn.layer.cornerRadius = 3.0;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1.0f;
            btn.layer.borderColor = Color(235, 235, 235, 1.0).CGColor;
            
            [bestSeatView addSubview:btn];
            switch (i) {
                case 0:
                    self.oneSeatBtn = btn;
                    break;
                case 1:
                    self.twoSeatBtn = btn;
                    break;
                case 2:
                    self.threeSeatBtn = btn;
                    break;
                case 3:
                    self.fourSeatBtn = btn;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)configMovieRoomWithDict:(NSDictionary *)dict
{
    self.nameLb.text = dict[@"name"];
    switch ([dict[@"index"] intValue]) {
        case 0:
            self.dateLb.text = [NSString stringWithFormat:@"今天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
            break;
        case 1:
            self.dateLb.text = [NSString stringWithFormat:@"明天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] +86400] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
            break;
        case 2:
            self.dateLb.text = [NSString stringWithFormat:@"后天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] +86400 * 2] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
            break;
        default:
            break;
    }
    CGSize dateSize = [self.dateLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.dateLb.frame = CGRectMake(12, 40, dateSize.width, 15);
    self.timeLb.text = [[NSString stringWithFormat:@"%@",dict[@"start_time"]] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    CGSize timeSize = [self.timeLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.timeLb.frame = CGRectMake(12 +dateSize.width +8, 40, timeSize.width +3, 15);
    if (![dict[@"tags"] isEqual:[NSNull null]]) {
        self.typeLb.text = [NSString stringWithFormat:@"%@%@",dict[@"language"],dict[@"tags"]];
    }else{
        self.typeLb.text = [NSString stringWithFormat:@"%@",dict[@"language"]];
    }
    CGSize typeSize = [self.typeLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.typeLb.frame = CGRectMake(12 +dateSize.width +8 +timeSize.width +3 +8, 40, typeSize.width +10, 15);
}

- (void)SelectSeatViewEvents:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoSelectSeatViewEvent:)]) {
        [self.delegate gotoSelectSeatViewEvent:btn.tag];
    }
}

- (void)changeBestSeatViewWith:(NSArray *)seatsArray SeatsCount:(NSInteger)count
{
    if (count == 1) {
        [self helpBestSeatViewWith:seatsArray];
        self.twoSeatBtn.hidden = YES;
        self.threeSeatBtn.hidden = YES;
        self.fourSeatBtn.hidden = YES;
    }else{
        [self helpBestSeatViewWith:seatsArray];
    }
}

- (void)helpBestSeatViewWith:(NSArray *)seatsArray
{
    if (seatsArray.count == 0) {
        for (UIView *view in _bestView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                view.hidden = NO;
                [(UIButton *)view setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [(UIButton *)view setImageEdgeInsets:UIEdgeInsetsMake(8, 70, 8, 0)];
                [(UIButton *)view setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 0)];
            }
        }
        [self.oneSeatBtn setTitle:@"1座" forState:UIControlStateNormal];
        [self.twoSeatBtn setTitle:@"2座" forState:UIControlStateNormal];
        [self.threeSeatBtn setTitle:@"3座" forState:UIControlStateNormal];
        [self.fourSeatBtn setTitle:@"4座" forState:UIControlStateNormal];
    }else{
        for (UIView *view in _bestView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                if (view.tag < 667 +seatsArray.count) {
                    UIButton *Button = (UIButton *)view;
                    [Button setImage:[UIImage imageNamed:@"cancel_seat"] forState:UIControlStateNormal];
                    [Button setImageEdgeInsets:UIEdgeInsetsMake(8, Button.frame.size.width -10, 8, 0)];
                    [Button setTitleEdgeInsets:UIEdgeInsetsMake(8, -5, 8, 5)];
                    view.hidden = NO;
                    ZFSeatButton *btn = seatsArray[view.tag -667];
                    //ZFSeatsModel *seatsModel = btn.seatsmodel;
                    ZFSeatModel *seatModel = btn.seatmodel;
                    NSInteger row = [seatModel.rowValue integerValue];
                    NSInteger col = [seatModel.columnValue integerValue];
                    //NSLog(@"%zd排%zd座",row,col);
                    [Button setTitle:[NSString stringWithFormat:@"%zd排%zd座",row,col] forState:UIControlStateNormal];
                }else{
                    view.hidden = YES;
                }
            }
        }
    }
}

@end
