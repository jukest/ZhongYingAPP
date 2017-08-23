//
//  ItemBaseView.h
//  SimultaneousTest
//
//  Created by Leon.Hwa on 17/4/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemBaseViewBlock)(UITableView *,NSInteger *selectIndex);

@interface ItemBaseView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSMutableArray *datas;

@property (nonatomic, assign) BOOL shouldScroll;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ItemBaseViewBlock callBackBlock;

@property (nonatomic, strong) UIViewController *viewController;

- (void)renderWithIndex:(NSInteger)index;



@end
