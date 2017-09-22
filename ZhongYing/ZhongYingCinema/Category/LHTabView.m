//
//  LHTabView.m
//  SimultaneousTest
//
//  Created by Leon.Hwa on 17/4/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "LHTabView.h"
#import "LHTitleView.h"
#import "ItemBaseView.h"
#import "FilmCategoryTagView.h"
#import "ZYIntegralScrollBaseView.h"

@interface LHTabView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *itemContainer;
@property (nonatomic, strong) FilmCategoryTagView *titleView;
@end
@implementation LHTabView

- (instancetype)initWithItemsName:(NSArray *)itemsName withImages:(NSArray *)imges childrenView:(NSArray *)childrenView withTableView:(BOOL)isTableView withHasNavigationBar:(BOOL)hasNavigationBar isMain:(BOOL)isMain
{
    self = [super init];
    if (self) {
        
        _titleView = [[FilmCategoryTagView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TitleViewHeight) withItems:itemsName withImages:imges];
        
        [self addSubview:_titleView];

        CGFloat height = HEIGHT - 64 - TitleViewHeight - 49;
        if (!isMain) {
            height = HEIGHT - 64 - TitleViewHeight ;
        }
  
        _itemContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), WIDTH, height)];
        _itemContainer.pagingEnabled = YES;
        _itemContainer.bounces = NO;
        _itemContainer.delegate = self;
        _itemContainer.contentSize = CGSizeMake(WIDTH * itemsName.count, 0);

        [self addSubview:_itemContainer];
        
        for (NSInteger i = 0; i < childrenView.count; i++) {
            ZYIntegralScrollBaseView *itemView = childrenView[i];
            [itemView renderWithIndex:i withTableView:isTableView hasNavigationBar:hasNavigationBar isMain:isMain];
            [_itemContainer addSubview:itemView];
        }
        __weak typeof(self) weakSelf= self;
        _titleView.selectRow = ^(NSInteger row){
            [weakSelf.itemContainer setContentOffset:CGPointMake(WIDTH * row, 0)];
        };
        self.delegate = _titleView;
    }
    return self;
}

- (void)setFirstTitle:(NSString *)firstTitle {
    _firstTitle = firstTitle;
    UIButton *button = self.titleView.buttons[0];
    [button setTitle:firstTitle forState:UIControlStateNormal];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(LHTabViewDidScroll:)]){
        self.offset = scrollView.contentOffset;
        [self.delegate LHTabViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(LHTabViewDidEndDecelerating:)]){
        self.offset = scrollView.contentOffset;
        [self.delegate LHTabViewDidEndDecelerating:self];
    }
}

@end
