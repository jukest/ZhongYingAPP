//
//  ZYInformationBoxOfficeHeaderView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYInformationBoxOfficeHeaderView;
typedef enum : NSUInteger {
    ZYInformationBoxOfficeHeaderViewBtnEventAgoDay = 200,
    ZYInformationBoxOfficeHeaderViewBtnEventLaterDay,
    ZYInformationBoxOfficeHeaderViewBtnEventCalendar,
} ZYInformationBoxOfficeHeaderViewBtnEvent;

@protocol ZYInformationBoxOfficeHeaderViewDelegate <NSObject>

@optional
- (void)informationBoxOfficeHeaderView:(ZYInformationBoxOfficeHeaderView *)header buttonDidAction:(ZYInformationBoxOfficeHeaderViewBtnEvent)eventType;

@end

@interface ZYInformationBoxOfficeHeaderView : UIView

@property (nonatomic, weak) id <ZYInformationBoxOfficeHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSString *currentDate;

@property (nonatomic, strong) NSString *currentBoxOffice;

@property (nonatomic, strong) NSString *weekDay;

@end
