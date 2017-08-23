//
//  ViewPackagesView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewPackageViewDelegate <NSObject>

- (void)selectBtnDidClickedIndexpath:(NSIndexPath *)indexPath;

@end
@interface ViewPackagesView : UIView

@property(nonatomic,strong) UITableView *packageTableview;
@property(nonatomic,weak) id<ViewPackageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame packages:(NSArray *)goodsList;

@end
