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
//#import "CinemaDetailsViewCtl.h"
#import "Cinema.h"
#import "MovieDetailsViewCtl.h"
#import "CinemaCollectionViewCell.h"
#import "ZYCinemaDetailsViewController.h"
#import "ZYCinemaMainNetworkingRequst.h"


@interface MainView ()<MainTableViewControllerLoadDataDelegate,CinemaCollectionViewCellDelegate>
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
        
        
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataNowPlayingFilmNotification:) name:ZYCimemaUpdataNowPlayingFilmNotification object:nil];
        
    }
    
    return self;
}

- (void)addRefreshView
{
//    __weak typeof(self) weakSelf = self;
    
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
//        [weakSelf.collectionView reloadData];
        
        //发送通知 加载 更多数据
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYCimemaUpdataMoreNowPlayingFilmNotification object:nil];
    }];
    
}

- (void)endRefresh {
    if ([self.collectionView.mj_footer isRefreshing]) {
        [self.collectionView.mj_footer endRefreshing];
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ZYCinemaMainNetworkingRequst shareInstance].nowPlayingFilmArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CinemaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CinemaCollectionViewCell" forIndexPath:indexPath];
    cell.hotFilm = [ZYCinemaMainNetworkingRequst shareInstance].nowPlayingFilmArray[indexPath.item];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];

    MovieDetailsViewCtl *movieDetails = [[MovieDetailsViewCtl alloc] init];
    HotFilm *hotFilm = [ZYCinemaMainNetworkingRequst shareInstance].nowPlayingFilmArray[indexPath.row];
    movieDetails.hotFilm = hotFilm;
    movieDetails.cinemaMsg = self.cinemaMsg;
    movieDetails.filmsArr = [NSMutableArray arrayWithArray:[ZYCinemaMainNetworkingRequst shareInstance].nowPlayingFilmArray];
    movieDetails.type = @"海报";
    movieDetails.indexPath = indexPath.row;
    movieDetails.isApn = NO;
    [movieDetails setHidesBottomBarWhenPushed:YES];
    [vc.navigationController pushViewController:movieDetails animated:YES];
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




- (void)setViewController:(UIViewController *)viewController {
    self.vc = viewController;
    MainTableViewController *vc = (MainTableViewController *)viewController;
    vc.loadDataDelegate = self;
}







#pragma mark - CinemaCollectionViewCellDelegate
- (void)gotoCinemaCollectionViewCellEvents:(CinemaConllectionViewCellEvents)event indexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];

    
    HotFilm *film = [ZYCinemaMainNetworkingRequst shareInstance].nowPlayingFilmArray[indexPath.row];
    if (event == CinemaTableViewCellBuyEvents) {
        NSLog(@"购票");
        ZYCinemaDetailsViewController *cinemaDetails = [[ZYCinemaDetailsViewController alloc] init];
        cinemaDetails.film = film;
        cinemaDetails.title = @"购票";
        cinemaDetails.cinemaMsg = self.cinemaMsg;
        cinemaDetails.filmsArr = [NSMutableArray arrayWithArray:self.datas];
        cinemaDetails.indexPath = indexPath.row;
        [cinemaDetails setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:cinemaDetails animated:YES];
    }else if (event == CinemaTableViewCellPreSaleEvents){
        NSLog(@"预售");
        ZYCinemaDetailsViewController *cinemaDetails = [[ZYCinemaDetailsViewController alloc] init];
        cinemaDetails.film = film;
        cinemaDetails.title = @"预售";
        cinemaDetails.cinemaMsg = self.cinemaMsg;
        cinemaDetails.filmsArr = [NSMutableArray arrayWithArray:self.datas];
        cinemaDetails.indexPath = indexPath.row;
        [cinemaDetails setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:cinemaDetails animated:YES];
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
        [vc.navigationController pushViewController:movieDetails animated:YES];
    }
}


#pragma mark -- 通知相关
- (void)updataNowPlayingFilmNotification:(NSNotification *)noti {
    self.vc = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    self.datas = [ZYCinemaMainNetworkingRequst shareInstance].nowPlayingFilmArray;
    self.cinemaMsg = [ZYCinemaMainNetworkingRequst shareInstance].cinemaMsg;
    [self.collectionView reloadData];
    
    [self endRefresh];
    
    
    if (self.collectionView.mj_footer == nil) {
        
        [self addRefreshView];
    }
}



@end
