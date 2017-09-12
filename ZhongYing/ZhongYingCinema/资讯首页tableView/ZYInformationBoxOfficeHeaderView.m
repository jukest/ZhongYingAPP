//
//  ZYInformationBoxOfficeHeaderView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationBoxOfficeHeaderView.h"

@interface ZYInformationBoxOfficeHeaderView ()


/**
 日期相关的视图
 */
@property (nonatomic, strong) UIView *calendarView;

/**
 前一天
 */
@property (nonatomic, strong) UIButton *agoDayBtn;

/**
 后一天
 */
@property (nonatomic, strong) UIButton *laterDayBtn;

/**
 票房类型
 */
@property (nonatomic, strong) UILabel *boxOfficeTypeLabel;

/**
 日历按钮
 */
@property (nonatomic, strong) UIButton *calendarBtn;


/**
 票房相关的视图
 */
@property (nonatomic, strong) UIView *boxOfficeView;

@property (nonatomic, strong) UIView *bottomView;

/** 选择的日期 */
@property (nonatomic, strong) UILabel *selectedDate;

/** 实时票房 */
@property (nonatomic, strong) UILabel *realTimeBoxOfficeLabel;

/** 票房单位 */
@property (nonatomic, strong) UILabel *boxOfficeUnit;

/** 时间区域 */
@property (nonatomic, strong) UILabel *timeNameLabel;

/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSString *today;

@end

@implementation ZYInformationBoxOfficeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup {
    self.calendarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ZYInformationBoxOfficeHeaderViewCalendarViewHeigth)];
    self.calendarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.calendarView];
    
    CGFloat dayBtnWidth = 60;
    CGFloat marge = 10;
    
    //前一天按钮
    UIButton *agoDayBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(marge, 0, dayBtnWidth, self.calendarView.height) image:[UIImage imageNamed:@"back_btn"] target:self action:@selector(btnAction:) tag:ZYInformationBoxOfficeHeaderViewBtnEventAgoDay];
    [agoDayBtn setTitle:@"前一天" forState:UIControlStateNormal];
    agoDayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [agoDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    agoDayBtn.backgroundColor = [UIColor clearColor];
    agoDayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.calendarView addSubview:agoDayBtn];
    self.agoDayBtn = agoDayBtn;
    
    //日历
    CGFloat space = (self.calendarView.width - 2 * (dayBtnWidth + marge ) - 140) * 0.5;
    CGFloat x = space + CGRectGetMaxX(self.agoDayBtn.frame);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 140, self.calendarView.height)];
    [self.calendarView addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *boxOfficeType = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 40, self.calendarView.height) text:@"日票房" font:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
    [view addSubview:boxOfficeType];
    self.boxOfficeTypeLabel = boxOfficeType;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(boxOfficeType.width + 2, (self.calendarView.height - 10)*0.5, 2, 10)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    UIButton *calendarBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) , 0, view.width - lineView.width - boxOfficeType.width, self.calendarView.height) image:[UIImage imageNamed:@"movie_more"] target:self action:@selector(btnAction:) tag:ZYInformationBoxOfficeHeaderViewBtnEventCalendar];
    calendarBtn.backgroundColor = [UIColor clearColor];
    
    
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    NSString *month = comp.month > 9 ? [NSString stringWithFormat:@"%ld",(long)comp.month]:[NSString stringWithFormat:@"0%ld",(long)comp.month];
    NSString *day = comp.day > 9 ?[NSString stringWithFormat:@"%ld",(long)comp.day]:[NSString stringWithFormat:@"0%ld",(long)comp.day];
    NSString *currentDateStr = [NSString stringWithFormat:@"%ld-%@-%@",(long)comp.year,month,day];
    self.currentDate = currentDateStr;
    self.today = currentDateStr;
    
    [calendarBtn setTitle:currentDateStr forState:UIControlStateNormal];
    calendarBtn.titleLabel.backgroundColor = [UIColor clearColor];
    calendarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    [calendarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    calendarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    calendarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [view addSubview:calendarBtn];
    self.calendarBtn = calendarBtn;
    
    //后一天
    UIButton *laterDayBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(CGRectGetMaxX(view.frame)+space, 0, dayBtnWidth, self.calendarView.height) image:[UIImage imageNamed:@"rigth_arrow"] target:self action:@selector(btnAction:) tag:ZYInformationBoxOfficeHeaderViewBtnEventLaterDay];
    laterDayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [laterDayBtn setTitle:@"后一天" forState:UIControlStateNormal];
    laterDayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, 0);
    laterDayBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [laterDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.calendarView addSubview:laterDayBtn];
    self.laterDayBtn = laterDayBtn;
    
    //实时票房
    self.boxOfficeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.calendarView.height, self.width, self.height - self.calendarView.height)];
    self.boxOfficeView.backgroundColor = Color(252, 186, 0, 1.0);
    [self addSubview:self.boxOfficeView];
    
    
    //选择的日期
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 200, self.boxOfficeView.height - 20)];
    [self.boxOfficeView addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor clearColor];
    
    //今日实时
    self.selectedDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 25, bottomView.height - 20 - 5)];
    self.selectedDate.numberOfLines = 2;
    self.selectedDate.text = @"今日实时";
    self.selectedDate.font = [UIFont systemFontOfSize:12];
    self.selectedDate.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:self.selectedDate];
    
    //票房数据
    self.realTimeBoxOfficeLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(self.selectedDate.width, 0, bottomView.width - self.selectedDate.width - 10, bottomView.height-20) text:@"288.0" font:[UIFont systemFontOfSize:50] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    [bottomView addSubview:self.realTimeBoxOfficeLabel];
    self.realTimeBoxOfficeLabel.backgroundColor = [UIColor clearColor];
    [self.realTimeBoxOfficeLabel sizeToFit];
    
    //单位
    self.boxOfficeUnit = [FanShuToolClass createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.realTimeBoxOfficeLabel.frame), self.bottomView.height - 20 - 20 - 5, 20, 20) text:@"万" font:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [self.bottomView addSubview:self.boxOfficeUnit];
    
    
    
    
    //时间
    self.timeNameLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, self.selectedDate.height, self.bottomView.width * 0.4, 20) text:@"北京时间" font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
    [self.bottomView addSubview:self.timeNameLabel];
    
    //定时器 反复执行
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.timeLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(self.bottomView.width * 0.4 + 10, self.selectedDate.height, self.bottomView.width * 0.6 - 10, 20) text:@"00:00:00" font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [self.bottomView addSubview:self.timeLabel];
    
    
    self.bottomView.frame = CGRectMake(0, 10, self.selectedDate.width + self.realTimeBoxOfficeLabel.width + self.boxOfficeUnit.width, self.boxOfficeView.height - 20);
    
    x = (self.boxOfficeView.width - self.bottomView.width) * 0.5;
    
    self.bottomView.frame = CGRectMake(x, 10, self.selectedDate.width + self.realTimeBoxOfficeLabel.width + self.boxOfficeUnit.width, self.boxOfficeView.height - 20);

    
}

#pragma mark --定时器
-(void)updateTime{
 
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    
    [dataFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *dateString = [dataFormatter stringFromDate:currentDate];
    
    self.timeLabel.text = dateString;
    
}

#pragma mark -- 按钮点击事件
- (void)btnAction:(UIButton *)sender {
//    NSLog(@"%ld",(long)sender.tag);
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(informationBoxOfficeHeaderView:buttonDidAction:)]) {
            [self.delegate informationBoxOfficeHeaderView:self buttonDidAction:sender.tag];
        }
    }
}


- (void)setCurrentBoxOffice:(NSString *)currentBoxOffice {
    _currentBoxOffice = currentBoxOffice;
    
    self.realTimeBoxOfficeLabel.text = currentBoxOffice;
    [self.realTimeBoxOfficeLabel sizeToFit];
    
    if (self.realTimeBoxOfficeLabel.width < 100) {
        self.realTimeBoxOfficeLabel.frame = CGRectMake(self.realTimeBoxOfficeLabel.x, self.realTimeBoxOfficeLabel.y, 100, self.realTimeBoxOfficeLabel.height);
    }
    
    self.boxOfficeUnit.frame = CGRectMake(CGRectGetMaxX(self.realTimeBoxOfficeLabel.frame), self.boxOfficeUnit.y, self.boxOfficeUnit.width, self.boxOfficeUnit.height);

    CGFloat width = self.selectedDate.width + self.realTimeBoxOfficeLabel.width + self.boxOfficeUnit.width;
    if (width < 130) {
        width = 130;
    }
    CGFloat x = (self.boxOfficeView.width - width) * 0.5;

    self.bottomView.frame = CGRectMake(x, 10, width, self.boxOfficeView.height - 20);

    self.timeNameLabel.frame = CGRectMake(0, self.selectedDate.height, self.bottomView.width * 0.4, 20);
    self.timeLabel.frame = CGRectMake(self.bottomView.width * 0.4 + 10, self.selectedDate.height, self.bottomView.width * 0.6 - 10, 20);
    
}

- (void)setWeekDay:(NSString *)weekDay {
    _weekDay = weekDay;
//    if ([self.currentDate isEqualToString:self.today]) {
//        self.selectedDate.text = @"今日实时";
//    } else {
//        
//        self.selectedDate.text = [NSString stringWithFormat:@"%@预售",weekDay];
//    }
    
    NSString *starTimer=self.currentDate;
    NSString *finishTimer=self.today;
    
   if ([starTimer compare:finishTimer] == NSOrderedSame) {//相等
       self.selectedDate.text = @"今日实时";
   } else if ([starTimer compare:finishTimer] == NSOrderedDescending) {
       self.selectedDate.text = [NSString stringWithFormat:@"%@预售",weekDay];

   } else if ([starTimer compare:finishTimer] == NSOrderedAscending) {
       self.selectedDate.text = [NSString stringWithFormat:@"%@",weekDay];

   }
    
    
}

- (void)setCurrentDate:(NSString *)currentDate {
    _currentDate = currentDate;
    [self.calendarBtn setTitle:currentDate forState:UIControlStateNormal];
}


@end
















