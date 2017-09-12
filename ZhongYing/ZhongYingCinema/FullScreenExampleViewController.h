//
//  FullScreenExample.h
//  FSCalendar
//
//  Created by Wenchao Ding on 9/16/15.
//  Copyright (c) 2015 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSCalendar;
typedef void(^CalenderSelectedBlock)(FSCalendar *calender,NSDate *date,NSString *dateStr);

@interface FullScreenExampleViewController : UIViewController

@property (nonatomic, strong) CalenderSelectedBlock selectedCalenderBlock;

@end
