//
//  PaymentView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/27.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMovieView.h"

typedef NS_ENUM(NSInteger,PaymentShowMessage){
   PaymentShowMovieMessage = 0,
   PaymentNotShowMovieMessage
};

@interface PaymentView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(PaymentShowMessage)type packageArr:(NSArray *)packages movieMessage:(NSDictionary *)message;

@end
