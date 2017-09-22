//
//  ZYIntegralScrollBaseView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIntegralCell.h"
#import "ExchangeRecordCell.h"

typedef void(^ItemBaseViewBlock)(UITableView *,NSInteger *selectIndex);


@interface ZYIntegralScrollBaseView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *datas;

@property (nonatomic, assign) BOOL shouldScroll;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ItemBaseViewBlock callBackBlock;

@property (nonatomic, strong) UIViewController *viewController;

- (void)renderWithIndex:(NSInteger)index withTableView:(BOOL)isTableView hasNavigationBar:(BOOL)hasNavigationBar isMain:(BOOL)isMain;

@end
