//
//  ItemBaseView.m
//  SimultaneousTest
//
//  Created by Leon.Hwa on 17/4/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "ItemBaseView.h"
#import "CinemaCollectionViewCell.h"

@interface ItemBaseView()
@property (nonatomic, assign)BOOL hasNavigationBar;
@end
@implementation ItemBaseView





- (void)renderWithIndex:(NSInteger)index withTableView:(BOOL)isTableView hasNavigationBar:(BOOL)hasNavigationBar
{
    self.hasNavigationBar = hasNavigationBar;
    if (isTableView) {//tableView
        [self setupTalbeView];
    } else { //collectionView
    [self setupCollectionView];
    }
    
    self.frame = CGRectMake(WIDTH * index, 0, WIDTH, HEIGHT - 20 - TitleViewHeight - 49);
    self.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAction:) name:TabViewScrollToTopNotification object:nil];
    
}

- (void)setupTalbeView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT - (self.hasNavigationBar?NavigationHeight:20) - TitleViewHeight - 49) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[CinemaCollectionViewCell class] forCellWithReuseIdentifier:@"CinemaCollectionViewCell"];
    self.collectionView.backgroundColor = Color(246, 246, 246, 1);
    [self addSubview:self.collectionView];
    
    //注册尾部
    // 注册尾部
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
    flowLayout.footerReferenceSize = CGSizeMake(self.collectionView.width, 50);

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
        
        [[NSNotificationCenter defaultCenter]  postNotificationName:ItemScrollToTopNotification object:@(YES)];
        
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




#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ItemBaseViewConllectViewCellLineSpace ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return ItemBaseViewConllectViewCellInteritemSpace ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(ItemBaseViewConllectViewCellWidth , ItemBaseViewConllectViewCellHeight );
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat top = 10;
    CGFloat bottom = 10;
    
    CGFloat left = (ScreenWidth - ItemBaseViewConllectViewCellWidth  * 2 - ItemBaseViewConllectViewCellInteritemSpace ) *  0.5;
    
    
    return UIEdgeInsetsMake(top, left, bottom, left);
    
}


@end
