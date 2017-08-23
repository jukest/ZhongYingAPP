//
//  ZYPositionCityTableViewController.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PostionCityBlock)(NSString *city);

@interface ZYPositionCityTableViewController : UITableViewController

@property (nonatomic,strong) PostionCityBlock positionBlock;

@end
