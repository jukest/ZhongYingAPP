//
//  WXTabView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "WXTabView.h"
#import "LHTitleView.h"
#import "ItemBaseView.h"
#import "FilmCategoryTagView.h"
#import "ZYInformationScrollBaseView.h"

@interface WXTabView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *itemContainer;
@property (nonatomic, strong) FilmCategoryTagView *titleView;
@end

@implementation WXTabView

- (instancetype)initWithItemsName:(NSArray *)itemsName withImages:(NSArray *)imges childrenView:(NSArray *)childrenView withTableView:(BOOL)isTableView withHasNavigationBar:(BOOL)hasNavigationBar
{
    self = [super init];
    if (self) {
        
        _titleView = [[FilmCategoryTagView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TitleViewHeight) withItems:itemsName withImages:imges];
        
        [self addSubview:_titleView];
        
        
        _itemContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), WIDTH, HEIGHT - (hasNavigationBar?NavigationHeight:0) - TitleViewHeight - 49)];
        _itemContainer.pagingEnabled = YES;
        _itemContainer.bounces = NO;
        _itemContainer.delegate = self;
        _itemContainer.contentSize = CGSizeMake(WIDTH * itemsName.count, 0);
        
        [self addSubview:_itemContainer];
        
        for (NSInteger i = 0; i < childrenView.count; i++) {
            ZYInformationScrollBaseView *itemView = childrenView[i];
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
    if([self.delegate respondsToSelector:@selector(WXTabViewDidScroll:)]){
        self.offset = scrollView.contentOffset;
        [self.delegate WXTabViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(LHTabViewDidEndDecelerating:)]){
        self.offset = scrollView.contentOffset;
        [self.delegate WXTabViewDidEndDecelerating:self];
    }
}


@end
