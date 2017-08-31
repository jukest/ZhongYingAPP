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

@interface LHTabView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *itemContainer;
@property (nonatomic, strong) FilmCategoryTagView *titleView;
@end
@implementation LHTabView

- (instancetype)initWithItemsName:(NSArray *)itemsName childrenView:(NSArray <ItemBaseView *>*)childrenView withTableView:(BOOL)isTableView withHasNavigationBar:(BOOL)hasNavigationBar
{
    self = [super init];
    if (self) {
        
        _titleView = [[FilmCategoryTagView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TitleViewHeight) withItems:itemsName];
        [self addSubview:_titleView];

  
        _itemContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), WIDTH, HEIGHT - (hasNavigationBar?NavigationHeight:20) - TitleViewHeight - 49)];
        _itemContainer.pagingEnabled = YES;
        _itemContainer.bounces = NO;
        _itemContainer.delegate = self;
        _itemContainer.contentSize = CGSizeMake(WIDTH * itemsName.count, 0);

        [self addSubview:_itemContainer];
        
        for (NSInteger i = 0; i < childrenView.count; i++) {
            ItemBaseView *itemView = childrenView[i];
            [itemView renderWithIndex:i withTableView:isTableView hasNavigationBar:hasNavigationBar];
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
