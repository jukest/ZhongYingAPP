//
//  WXSegementControl.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SegementControlCallBlock)(NSInteger);


@protocol WXSegementControlDelegate <NSObject>

@optional
- (void)segementControlDidSelectIndex:(NSInteger)index;

@end

@interface WXSegementControl : UIView


@property (nonatomic, strong)NSMutableArray <UIButton *> *buttons;


@property (nonatomic, strong) UIColor *selectedTitleColor;

- (void)btnAction:(UIButton *)sender;

//- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state forIndex:(NSInteger)index;

//- (void)setBackgroundColor:(UIColor *)color forIndex:(NSInteger)index;
//- (void)setSelectedBackgroundColor:(UIColor *)color forIndex:(NSInteger)index;

//- (void)setTitle:(NSString *)title forState:(UIControlState)state forIndex:(NSInteger)index;

//- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
//- (void)setImage:(UIImage *)image forState:(UIControlState)state;
//- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;





+(instancetype)segementControlWithFrame:(CGRect)frame withItems:(NSArray <NSString *>*)items;
-(instancetype)initWithFrame:(CGRect)frame withItems:(NSArray <NSString *>*)items;
@property (nonatomic, weak) id <WXSegementControlDelegate> delegate;

/** 回调 */
@property (nonatomic, strong) SegementControlCallBlock callBackBlock;



@end
