//
//  MainTableView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 小菜皮. All rights reserved.
// 嵌套的底层tableView

#import "MainTableView.h"

@implementation MainTableView


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
