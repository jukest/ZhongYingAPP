//
//  ZYMyUpListView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYMyUpListView;
@protocol ZYMyUpListViewDelegate <NSObject>

- (void)myUpListView:(ZYMyUpListView *)myupListView buttonDidClick:(UIButton *)button;

@end

@interface ZYMyUpListView : UIView
- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray <NSString *> *)imgs withTitles:(NSArray <NSString *> *)titles;
@property (nonatomic, weak) id <ZYMyUpListViewDelegate> delegate;

@property (nonatomic, strong) NSString *comment;

@end
