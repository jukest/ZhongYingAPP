//
//  InformationViewController.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"

@interface InformationViewController : ZYViewController

@property(nonatomic,strong) UITableView *informationTableView;
@property(nonatomic,strong) NSMutableArray *informationArr;
@property(nonatomic,strong) NSMutableArray *slidersArr;
@property(nonatomic,assign) NSInteger currentPage;

- (void)loadNewsMessage;

@end
