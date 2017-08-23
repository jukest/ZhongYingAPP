//
//  MyCollectionCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"

@interface MyCollectionCell : UITableViewCell

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *typesLb;
@property(nonatomic,strong) UILabel *detailsLb;
@property(nonatomic,strong) UIButton *is3DImg;

- (void)configCellWithModel:(Collection *)collection;

@end
