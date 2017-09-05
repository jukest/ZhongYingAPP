//
//  ZYConfirmOrderTableViewHeader.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYConfirmOrderTableViewHeader.h"
#import "ZFSeatButton.h"

@interface ZYConfirmOrderTableViewHeader (){
    NSInteger _time;
}
@property(nonatomic,strong) UIButton *countdownLb;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *typeLb;
@property(nonatomic,strong) UILabel *cinemaNameLb;
@property(nonatomic,strong) UILabel *hallLb;
@property(nonatomic,strong) UILabel *seatNumberLb;
@property(nonatomic,strong) UILabel *snackLb;
@property(nonatomic,strong) UILabel *totalPriceLb;
@property(nonatomic,strong) UIButton *couponLb;
@property(nonatomic,strong) UILabel *finalPaymentLb;
@property(nonatomic,strong) NSTimer *myTimer;

@property (nonatomic, strong)NSDictionary *dic;
@property (nonatomic, strong)NSString *cinema_name;
@property (nonatomic, strong)NSArray *seats;


@end


@implementation ZYConfirmOrderTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = Color(252, 186, 0, 0.9);
        _time = 8 * 60;
        
    }
    return self;
}

- (void)setUpFilmInfo:(NSDictionary *)filmDic withCinema_name:(NSString *)cinema_name withSelectSeat:(NSArray *)seats{
    self.dic = filmDic;
    self.cinema_name = cinema_name;
    self.seats = seats;
    [self setupUI];
}

- (void)setupUI {
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, 20, ScreenWidth - 2 * 30, self.height - 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    
    
   
    CGFloat y = 0;
    CGFloat marge = 10;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.height - ZYConfirmOrderTableViewHeaderXuXianBottomHeight - 2, view.width, 4)];
    imageView.image = [UIImage imageNamed:@"xuXian"];
    [view addSubview:imageView];

    
    //支付剩余时间
    self.countdownLb = [FanShuToolClass createButtonWithFrame:CGRectMake(view.width  - 100, marge, 100, 20)
                                                        title:@"支付剩余时间"
                                                   titleColor:[UIColor blackColor]
                                                       target:nil
                                                       action:nil
                                                          tag:100];
    self.countdownLb.titleLabel.font = [UIFont systemFontOfSize:15];
    self.countdownLb.titleLabel.textColor = Color(82, 82, 82, 1.0);
    self.countdownLb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [view addSubview:self.countdownLb];
    
    //时间显示
    self.timeLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(view.width  - 50, CGRectGetMaxY(self.countdownLb.frame), 50, 20) text:@"8:00" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
//    [view addSubview:self.timeLabel];
    
    
    
    UIView *movieDetailsView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 42, ScreenWidth, 124) backgroundColor:[UIColor whiteColor]];
//    [scrollView addSubview:movieDetailsView];
    
    //电影名
    self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, marge, view.width - self.countdownLb.width - marge, 20)
                                                   text:self.dic[@"name"]
                                                   font:[UIFont systemFontOfSize:20]
                                              textColor:Color(26, 26, 26, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [view addSubview:self.nameLb];
    
    NSString *date = @"";
    NSString *d = [[NSString stringWithFormat:@"%@",self.dic[@"start_time"]] transforTomyyyyMMddWithFormatter:@"MM月dd日"];
    switch ([@"1" integerValue]) {
        case 1: //今天
            date = [NSString stringWithFormat:@"今天%@",d];
            break;
        case 2: //明天
            date = [NSString stringWithFormat:@"明天%@",d];
            break;
        case 3: //后天
            date = [NSString stringWithFormat:@"后天%@",d];
            break;
        default:
            break;
    }
    CGSize dateSize = [date sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    y = CGRectGetMaxY(self.nameLb.frame) + marge;
    self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, dateSize.width, 15)
                                                   text:date
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(248, 109, 128, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [view addSubview:self.dateLb];
    
    NSString *time = [[NSString stringWithFormat:@"%@",self.dic[@"start_time"]] transforTomyyyyMMddWithFormatter:@"HH:mm"];
    CGSize timeSize = [time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(marge + dateSize.width, y, timeSize.width, 15)
                                                   text:time
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(248, 109, 128, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [view addSubview:self.timeLb];
    
    self.typeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(marge +dateSize.width +15 +timeSize.width +12, y, 200, 15)
                                                   text:[NSString stringWithFormat:@"(%@%@)",self.dic[@"language"],self.dic[@"tags"]]
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(150, 150, 150, 1.0)
                                              alignment:NSTextAlignmentLeft];
    NSString *str1 = @"";
    if (![self.dic[@"language"] isEqual:[NSNull null]]) {
        str1 = [NSString stringWithFormat:@"%@%@",str1,self.dic[@"language"]];
    }
    if (![self.dic[@"tags"] isEqual:[NSNull null]]) {
        str1 = [NSString stringWithFormat:@"%@%@",str1,self.dic[@"tags"]];
    }
    self.typeLb.text = [NSString stringWithFormat:@"(%@)",str1];
    [view addSubview:self.typeLb];
    
    NSString *cinemaName = self.cinema_name;
    
    y = CGRectGetMaxY(self.dateLb.frame) + marge;
    CGSize cinemaSize = [cinemaName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.cinemaNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, cinemaSize.width, 15)
                                                         text:cinemaName
                                                         font:[UIFont systemFontOfSize:15]
                                                    textColor:Color(82, 82, 82, 1.0)
                                                    alignment:NSTextAlignmentLeft];
    [view addSubview:self.cinemaNameLb];
    
    self.hallLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +cinemaSize.width +15, y, 200, 15)
                                                   text:self.dic[@"hall_name"]
                                                   font:[UIFont systemFontOfSize:15]
                                              textColor:Color(82, 82, 82, 1.0)
                                              alignment:NSTextAlignmentLeft];
    [movieDetailsView addSubview:self.hallLb];
    
    NSString *seatStr;
    NSMutableArray *seats = [NSMutableArray array];
    for (ZFSeatButton *seatButton in self.seats) {
        ZFSeatModel *seatModel = seatButton.seatmodel;
        NSInteger row = [seatModel.rowValue integerValue];
        NSInteger col = [seatModel.columnValue integerValue];
        [seats addObject:[NSString stringWithFormat:@"%zd排%zd座",row,col]];
    }
    seatStr = [seats componentsJoinedByString:@" "];
    y = CGRectGetMaxY(self.hallLb.frame) + marge;
    self.seatNumberLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, y, view.width, 15)
                                                         text:seatStr
                                                         font:[UIFont systemFontOfSize:15]
                                                    textColor:Color(82, 82, 82, 1.0)
                                                    alignment:NSTextAlignmentLeft];
    [view addSubview:self.seatNumberLb];

    UIButton *btn1 = [FanShuToolClass createButtonWithFrame:CGRectMake(0, view.height - ZYConfirmOrderTableViewHeaderXuXianBottomHeight, 80, ZYConfirmOrderTableViewHeaderXuXianBottomHeight) image:[UIImage imageNamed:@"order_no"] target:nil action:nil tag:101];
    [btn1 setTitleColor:Color(82, 82, 82, 1.0) forState:UIControlStateNormal];
    [btn1 setTitle:@"不可退票" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:btn1];
    
    UIButton *btn2 = [FanShuToolClass createButtonWithFrame:CGRectMake(80, view.height - ZYConfirmOrderTableViewHeaderXuXianBottomHeight, view.width - 80, ZYConfirmOrderTableViewHeaderXuXianBottomHeight) image:[UIImage imageNamed:@"order_yes"] target:nil action:nil tag:101];
    [btn2 setTitleColor:Color(82, 82, 82, 1.0) forState:UIControlStateNormal];
    [btn2 setTitle:@"开场前1小时可改签(有改签费)" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:btn2];
    
//    UILabel *label = [FanShuToolClass createLabelWithFrame:CGRectMake(0, view.height - ZYConfirmOrderTableViewHeaderXuXianBottomHeight, view.width, ZYConfirmOrderTableViewHeaderXuXianBottomHeight) text:@"不可退票 开场前1小时可改签(有改签费)" font:[UIFont systemFontOfSize:14] textColor:Color(82, 82, 82, 1.0) alignment:NSTextAlignmentCenter];
//    [view addSubview:label];
    
//    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    
    CGFloat height = rect.size.height;
    
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    
    CGFloat radius = ZYConfirmOrderTableViewHeaderRadius;
    
    CGFloat marge = ZYConfirmOrderTableViewHeaderMarge;
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // 移动到初始点
    
    CGContextMoveToPoint(context, marge + radius, marge);
    
    
    
    // 绘制第1条线和第1个1/4圆弧，右上圆弧
    
    CGContextAddLineToPoint(context, width - (radius + marge),marge);
    
    CGContextAddArc(context, width - (radius + marge), marge + radius, radius, -0.5 *M_PI,0.0,0);
    
    
    // 绘制第2条线和第2个1/4圆弧，右下圆弧
    

    CGContextAddLineToPoint(context, width - marge, height - (marge + ZYConfirmOrderTableViewHeaderXuXianBottomHeight + radius));
    
    CGContextAddArc(context, width - marge , height -  (marge + ZYConfirmOrderTableViewHeaderXuXianBottomHeight), radius,-0.5 * M_PI, 0.5 * M_PI,1);

    CGContextAddLineToPoint(context, width - marge, height - (marge + radius));

    
    CGContextAddArc(context, width - (marge + radius), height -  (marge + radius), radius,0.0,0.5 *M_PI,0);
    
    
    
    
    // 绘制第3条线和第3个1/4圆弧，左下圆弧
    
    CGContextAddLineToPoint(context, marge + radius, height - marge);
    
    CGContextAddArc(context, marge + radius, height - radius - marge, radius,0.5 *M_PI,M_PI,0);
    
    
    
    // 绘制第4条线和第4个1/4圆弧，左上圆弧
    
    
    CGContextAddLineToPoint(context, marge, height - marge - ZYConfirmOrderTableViewHeaderXuXianBottomHeight  + radius);
    CGContextAddArc(context, marge, height - marge - ZYConfirmOrderTableViewHeaderXuXianBottomHeight, radius, 0.5*M_PI, -0.5*M_PI, 1);
    
    
    CGContextAddLineToPoint(context, marge,marge + radius);
    
    CGContextAddArc(context, radius + marge, marge + radius, radius,M_PI,1.5 *M_PI,0);
    
    
    
    
    // 闭合路径
    
//    CGContextClosePath(context);
    
    // 填充半透明红色
    
//    CGContextSetRGBFillColor(context,1.0,0.0,0.0,0.5);
    
    CGContextDrawPath(context,kCGPathFill);
    
    
}
- (void)timerCutWithTime:(NSInteger)time {
    
    
   NSString *tStr = [NSString stringWithFormat:@"%zd",time];
    self.timeLabel.text = [tStr transforTomyyyyMMddWithFormatter:@"mm:ss"];
    
    
    //[NSString stringWithFormat:@"%d",time]stringwitf;  //[NSString stringWithFormat:@"%zd",time] transforTomyyyyMMddWithFormatter:@"mm:ss"];

}

@end
