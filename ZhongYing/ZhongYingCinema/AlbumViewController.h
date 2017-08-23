//
//  AlbumViewController.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/28.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ZYViewController.h"

@interface AlbumViewController : ZYViewController

@property(nonatomic,strong) UICollectionView *AlbumCollectionView;
@property(nonatomic,strong) NSArray *pictures;
@property(nonatomic,copy) NSString *name;

@end
