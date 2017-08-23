//
//  InfoDetailsViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "News.h"

typedef void(^commentNumBlock)(NSInteger);
typedef void(^rateNumBlock)(NSInteger);

@interface InfoDetailsViewCtl : UIViewController

@property(nonatomic,strong) UITableView *detailsTableView;
@property(nonatomic,strong) News *news;
@property(nonatomic,copy) commentNumBlock commentBlock;
@property(nonatomic,copy) rateNumBlock rateBlock;

@end
