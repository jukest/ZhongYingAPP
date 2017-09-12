//
//  ZYInformationScrollBaseView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYInformantionMainNetworingRequst.h"
#import "InfoTableViewCell.h"
#import "BoxOfficeTableViewCell.h"
#import "ZYInformationBoxOfficeCell.h"


typedef void(^ZYInformationScrollBaseViewBlock)(UITableView *,NSInteger *selectIndex);


@interface ZYInformationScrollBaseView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *datas;

@property (nonatomic, assign) BOOL shouldScroll;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYInformationScrollBaseViewBlock callBackBlock;

@property (nonatomic, strong) UIViewController *viewController;

- (void)renderWithIndex:(NSInteger)index withTableView:(BOOL)isTableView hasNavigationBar:(BOOL)hasNavigationBar;

@end
