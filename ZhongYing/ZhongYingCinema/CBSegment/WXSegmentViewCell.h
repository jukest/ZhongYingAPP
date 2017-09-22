//
//  WXSegmentViewCell.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/19.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXSegmentViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIView *selectedLine;

@end
