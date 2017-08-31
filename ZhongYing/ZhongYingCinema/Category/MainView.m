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
{

    MBProgressHUD *_HUD1;


}
@property (nonatomic, strong) CinemaComplaintView *complaintView;
@property (nonatomic, strong) UIView *sugeestView;
@property (nonatomic, strong) UIViewController *currentController;

@property (nonatomic, strong) UIViewController *vc;

@property(nonatomic,strong)  Cinema *cinemaMsg;   // 影院信息

@end

@implementation MainView

static NSString *cellID = @"cinemaCollectionCell";


- (UIView *)sugeestView {
    if (!_sugeestView) {
        _sugeestView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 40) backgroundColor:[UIColor whiteColor]];
        CGSize complaintSize = [@"投诉" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        for (int i = 0; i < 2; i ++) {
            UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(50 + ((ScreenWidth -100 -complaintSize.width) / 2 + complaintSize.width) * i, 25, (ScreenWidth -100 -complaintSize.width) / 2, 1) backgroundColor:Color(232, 232, 232, 1.0)];
            [_sugeestView addSubview:line];
        }
        UILabel *complaintLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, complaintSize.width +10, complaintSize.height) text:@"投诉" font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        complaintLb.backgroundColor = [UIColor whiteColor];
        complaintLb.center = CGPointMake(ScreenWidth / 2, 25);
        [_sugeestView addSubview:complaintLb];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(complaintBtnDidClicked:)];
        [_sugeestView addGestureRecognizer:tap];
    }
    return _sugeestView;
}


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


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    // UICollectionElementKindSectionHeader是一个const修饰的字符串常量,所以可以直接使用==比较
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
        
        footerView.backgroundColor = [UIColor whiteColor];
        
        [footerView addSubview:self.sugeestView];
        
        return footerView;

    }
    return nil;
    
    
}


- (void)setViewController:(UIViewController *)viewController {
    self.vc = viewController;
    MainTableViewController *vc = (MainTableViewController *)viewController;
    vc.loadDataDelegate = self;
}


#pragma mark - view Handles
- (void)complaintBtnDidClicked:(UIGestureRecognizer *)tap
{
    
    NSLog(@"投诉");
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) { // 用户未登录
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.vc.navigationController pushViewController:login animated:YES];
    }else{
        _complaintView = [[CinemaComplaintView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 240 * heightFloat)];
        _complaintView.delegate = self;
        [_complaintView show];
    }
}

#pragma mark - CinemaComplaintViewDelegate
- (void)sendComplaint:(NSString *)complaint
{
    [self keyBoardDown];
    
    if (complaint.length < 6) {
        [self showMessage:@"投诉至少6个字"];
    }else{
        if (_complaintView.complaintFld.text.length >= 6 && _complaintView.complaintFld.text.length <= 256) {
            
            _HUD1 = [FanShuToolClass createMBProgressHUDWithText:@"发送中..." target:self];
            [[UIApplication sharedApplication].keyWindow addSubview:_HUD1];
            
            NSLog(@"%@",complaint);
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserComplaintURL];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"token"] = ApiTokenStr;
            parameters[@"content"] = _complaintView.complaintFld.text;
            ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
            [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
                NSLog(@"sendComplaint >>>>>>>> %@",dataBack);
                if ([dataBack[@"code"] integerValue] == 0){
                    [self showMessage:@"投诉成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [_complaintView hiddenView];
                    });
                }
                [_HUD1 hide:YES];
            } failure:^(NSError *error) {
                [self showMessage:@"连接服务器失败!"];
                [_HUD1 hide:YES];
            }];
        }else{
            [self showMessage:@"投诉最多256个字"];
        }
    }
}

- (void)keyBoardDown
{
    [_complaintView.complaintFld resignFirstResponder];
}

- (void)showMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_complaintView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = 0 +90;
    hud.labelFont = [UIFont systemFontOfSize:15];
    [hud hide:YES afterDelay:1.0f];
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
