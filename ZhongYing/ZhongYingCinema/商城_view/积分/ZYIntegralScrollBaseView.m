//
//  ZYIntegralScrollBaseView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYIntegralScrollBaseView.h"

@interface ZYIntegralScrollBaseView ()

@property (nonatomic, assign)BOOL hasNavigationBar;
@property (nonatomic, assign)BOOL isMain;

@end

@implementation ZYIntegralScrollBaseView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}


- (void)renderWithIndex:(NSInteger)index withTableView:(BOOL)isTableView hasNavigationBar:(BOOL)hasNavigationBar isMain:(BOOL)isMain
{
    self.hasNavigationBar = hasNavigationBar;
    self.isMain = isMain;

    if (isTableView) {//tableView
        [self setupTalbeView];
    } else { //collectionView
//        [self setupCollectionView];
    }
    CGFloat height = HEIGHT - NavigationHeight - TitleViewHeight - 49;
    
    if (!isMain) {
        height = HEIGHT - NavigationHeight - TitleViewHeight;
    }
    
    self.frame = CGRectMake(WIDTH * index, 0, WIDTH, height);
    self.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAction:) name:ZYIntegralMianTableViewScrollToTopNotification object:nil];
    
}


- (void)setupTalbeView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT - 64 - TitleViewHeight - (self.isMain?49:0)) style:UITableViewStylePlain];
    [self.tableView registerClass:[MyIntegralCell class] forCellReuseIdentifier:@"MyIntegralCell"];
    [self.tableView registerClass:[ExchangeRecordCell class] forCellReuseIdentifier:@"ExchangeRecordCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self addSubview:self.tableView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}


- (void)scrollAction:(NSNotification *)noti{
    BOOL ret = [noti.object boolValue];
    self.shouldScroll = ret;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if(offsetY <= 0){
        
        [[NSNotificationCenter defaultCenter]  postNotificationName:ZYIntegralScrollBaseViewScrollToTopNotification object:@(YES)];
        
    }
    
    if(self.shouldScroll  == NO){
        [scrollView setContentOffset:CGPointZero];
    }
}




@end
