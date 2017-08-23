//
//  MainTableViewController.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableView.h"

@class MainTableViewController,MainTableView,Cinema;
@protocol MainTableViewControllerDelegate <NSObject>

@optional
//监听滚动的协议方法

/**
 正在滚动
 
 @param cinemaViewController 控制器
 @param scrollView 滚动的scrollView
 */
- (void)mainTableViewController:(MainTableViewController *)mainTableViewController scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 停止拖拽
 
 @param cinemaViewController 控制器
 @param scrollView 滚动的scrollView
 */
- (void)mianTableViewController:(MainTableViewController *)cinemaViewController scrollViewDidEndDragging:(UIScrollView *) scrollView;
@end


@protocol MainTableViewControllerLoadDataDelegate <NSObject>

@optional

/**
 数据请求完成

 @param mainTableViewController 网络请求控制器
 @param datas 数据
 */
- (void)mainTableViewControllerFinshLoadData:(MainTableViewController *)mainTableViewController dataArray:(NSArray *)datas withCinemaMsg:(Cinema *)cinemaMsg;


/**
 正在加载数据

 @param mainTableViewController 控制器
 */
- (void)mainTableViewControllerLoadingData:(MainTableViewController *)mainTableViewController;


/**
请求失败

 @param mainTableViewController 控制器
 @param errorString 失败原因
 */
- (void)mainTableViewControllerLoadingFailure:(MainTableViewController *)mainTableViewController withErrorString:(NSString *)errorString;

@end


@interface MainTableViewController : ZYViewController

@property (nonatomic,strong) MainTableView *mainTableView;

@property (nonatomic, weak) id <MainTableViewControllerDelegate> delegate;
@property(nonatomic, weak) id <MainTableViewControllerLoadDataDelegate> loadDataDelegate;
@end
