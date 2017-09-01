//
//  ZYInformationScrollBaseView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationScrollBaseView.h"

@interface ZYInformationScrollBaseView()
@property (nonatomic, assign)BOOL hasNavigationBar;
@end


@implementation ZYInformationScrollBaseView

- (void)renderWithIndex:(NSInteger)index withTableView:(BOOL)isTableView hasNavigationBar:(BOOL)hasNavigationBar
{
    self.hasNavigationBar = hasNavigationBar;
    if (isTableView) {//tableView
        [self setupTalbeView];
    } else { //collectionView

    }
    
    self.frame = CGRectMake(WIDTH * index, 0, WIDTH, HEIGHT - 20 - TitleViewHeight - 49);
    self.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAction:) name:ZYInformationTabViewScrollToTopNotification object:nil];
    
}

- (void)setupTalbeView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT - (self.hasNavigationBar?NavigationHeight:20) - TitleViewHeight - 49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    [self.tableView registerClass:[InfoTableViewCell class] forCellReuseIdentifier:@"informationTableViewCell"];
    [self.tableView registerClass:[BoxOfficeTableViewCell class] forCellReuseIdentifier:@"BoxOfficeTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


- (void)scrollAction:(NSNotification *)noti{
    BOOL ret = [noti.object boolValue];
    self.shouldScroll = ret;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if(offsetY <= 0){
        
        [[NSNotificationCenter defaultCenter]  postNotificationName:ZYInformationScrollBaseScrollToTopNotification object:@(YES)];
        
    }
    
    if(self.shouldScroll  == NO){
        [scrollView setContentOffset:CGPointZero];
    }
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}





@end
