//
//  ZYMallConfirmViewController.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYMallConfirmViewController : UIViewController

@property(nonatomic,strong) NSMutableArray *goodsList;

@property(nonatomic, strong) void(^callBack)(void);

@end
