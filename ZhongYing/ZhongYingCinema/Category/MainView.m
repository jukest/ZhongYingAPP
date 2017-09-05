//
//  MainView.m
//  SimultaneousTest
//
//  Created by Leon.Hwa on 17/4/28.
//  Copyright © 2017年 Leon. All rights reserved.
// 正在热映 视图

#import "MainView.h"
#import "CinemaTableViewCell.h"
#import "MainTableViewController.h"
#import "CinemaComplaintView.h"
#import "LoginViewController.h"
#import "CinemaDetailsViewCtl.h"
#import "Cinema.h"
#import "MovieDetailsViewCtl.h"
#import "CinemaCollectionViewCell.h"


@interface MainView ()<MainTableViewControllerLoadDataDelegate,CinemaCollectionViewCellDelegate,CinemaComplaintViewDelegate>
@property (nonatomic, strong) UIViewController *currentController;

@property (nonatomic, strong) UIViewController *vc;

@property(nonatomic,strong)  Cinema *cinemaMsg;   // 影院信息

@end

@implementation MainView

static NSString *cellID = @"cinemaCollectionCell";




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = random_color;
        
        
        
        //self.collectionView.tableFooterView.height = 50;
        //self.collectionView.tableFooterView = self.complaintView;
        
//        self.currentController = [self getCurrentVC];
        MainTableViewController *mainVC = (MainTableViewController *)self.viewController;
        mainVC.loadDataDelegate = self;
        
        
    }
    
    return self;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CinemaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CinemaCollectionViewCell" forIndexPath:indexPath];
    cell.hotFilm = self.datas[indexPath.item];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MovieDetailsViewCtl *movieDetails = [[MovieDetailsViewCtl alloc] init];
    HotFilm *hotFilm = self.datas[indexPath.row];
    movieDetails.hotFilm = hotFilm;
    movieDetails.cinemaMsg = self.cinemaMsg;
    movieDetails.filmsArr = [NSMutableArray arrayWithArray:self.datas];
    movieDetails.type = @"海报";
    movieDetails.indexPath = indexPath.row;
    movieDetails.isApn = NO;
    [movieDetails setHidesBottomBarWhenPushed:YES];
    [self.vc.navigationController pushViewController:movieDetails animated:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}


// 获取当前VC
- (UIViewController *)topVC:(UIViewController *)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navc = (UINavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    // UICollectionElementKindSectionHeader是一个const修饰的字符串常量,所以可以直接使用==比较
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
//        
//        footerView.backgroundColor = [UIColor whiteColor];
//        
//        [footerView addSubview:self.sugeestView];
//        
//        return footerView;
//
//    }
//    return nil;
//    
//    
//}


- (void)setViewController:(UIViewController *)viewController {
    self.vc = viewController;
    MainTableViewController *vc = (MainTableViewController *)viewController;
    vc.loadDataDelegate = self;
}





#pragma mark - MainTableViewControllerLoadDataDelegate
- (void)mainTableViewControllerFinshLoadData:(MainTableViewController *)mainTableViewController dataArray:(NSArray *)datas withCinemaMsg:(Cinema *)cinemaMsg{
    self.datas = [datas mutableCopy];
    self.cinemaMsg = cinemaMsg;
    [self.collectionView reloadData];
    
}


#pragma mark - CinemaCollectionViewCellDelegate
- (void)gotoCinemaCollectionViewCellEvents:(CinemaConllectionViewCellEvents)event indexPath:(NSIndexPath *)indexPath
{
    HotFilm *film = self.datas[indexPath.row];
    if (event == CinemaTableViewCellBuyEvents) {
        NSLog(@"购票");
        CinemaDetailsViewCtl *cinemaDetails = [[CinemaDetailsViewCtl alloc] init];
        cinemaDetails.film = film;
        cinemaDetails.title = @"购票";
        cinemaDetails.cinemaMsg = self.cinemaMsg;
        cinemaDetails.filmsArr = [NSMutableArray arrayWithArray:self.datas];
        cinemaDetails.indexPath = indexPath.row;
        [cinemaDetails setHidesBottomBarWhenPushed:YES];
        [self.vc.navigationController pushViewController:cinemaDetails animated:YES];
    }else if (event == CinemaTableViewCellPreSaleEvents){
        NSLog(@"预售");
        CinemaDetailsViewCtl *cinemaDetails = [[CinemaDetailsViewCtl alloc] init];
        cinemaDetails.film = film;
        cinemaDetails.title = @"预售";
        cinemaDetails.cinemaMsg = self.cinemaMsg;
        cinemaDetails.filmsArr = [NSMutableArray arrayWithArray:self.datas];
        cinemaDetails.indexPath = indexPath.row;
        [cinemaDetails setHidesBottomBarWhenPushed:YES];
        [self.vc.navigationController pushViewController:cinemaDetails animated:YES];
    }else if (event == CinemaTableViewCellPlayEvents){
        NSLog(@"播放");
        MovieDetailsViewCtl *movieDetails = [[MovieDetailsViewCtl alloc] init];
        HotFilm *hotFilm = self.datas[indexPath.row];
        movieDetails.hotFilm = hotFilm;
        movieDetails.cinemaMsg = self.cinemaMsg;
        movieDetails.filmsArr = [NSMutableArray arrayWithArray:self.datas];
        movieDetails.type = @"预告片";
        movieDetails.indexPath = indexPath.row;
        movieDetails.isApn = NO;
        [movieDetails setHidesBottomBarWhenPushed:YES];
        [self.vc.navigationController pushViewController:movieDetails animated:YES];
    }
}




@end
