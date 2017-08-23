//
//  FilmCategoryTagView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHTabView.h"

@protocol FilmCategoryTagViewDelegate <NSObject>

@optional
- (void)filmCategoryTagViewDidSelectIndex:(NSInteger)index;

@end



typedef void (^LHTitleViewSelectRow)(NSInteger row);


@interface FilmCategoryTagView : UIView<LHTabViewDelegate>



- (void)btnAction:(UIButton *)sender;


+(instancetype)filmCategoryTagViewWithFrame:(CGRect)frame withItems:(NSArray <NSString *>*)items;
-(instancetype)initWithFrame:(CGRect)frame withItems:(NSArray <NSString *>*)items;
@property (nonatomic, weak) id <FilmCategoryTagViewDelegate> delegate;


@property (nonatomic, copy) LHTitleViewSelectRow  selectRow;


@property (nonatomic, strong)NSMutableArray <UIButton *> *buttons;

@end
