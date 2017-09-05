//
//  ZYMoreListView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYMoreListView;
@protocol ZYMoreListViewDelegate <NSObject>

- (void)moreListView:(ZYMoreListView *)moreListView buttonDidClick:(UIButton *)button;

@end


@interface ZYMoreListView : UIView
- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray <NSString *> *)imgs withTitles:(NSArray <NSString *> *)titles;
@property (nonatomic, strong) id <ZYMoreListViewDelegate> delegate;

@end
