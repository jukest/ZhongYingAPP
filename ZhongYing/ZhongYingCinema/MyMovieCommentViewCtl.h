//
//  MyMovieCommentViewCtl.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/11.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"

@interface MyMovieCommentViewCtl : ZYViewController

@property(nonatomic,strong) UITableView *myMovieCommentTableView;

- (void)gotoEdit:(UIButton *)btn;

- (void)hideEditView;

@end
