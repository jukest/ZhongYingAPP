//
//  MainTableViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableView.h"
#import "Cinema.h"
#import "AppDelegate.h"
#import "HotFilm.h"
#import "CinemaSliderView.h"
#import "CinemaComplaintView.h"
#import "CustomCell.h"
#import "ZYCinemaMainNetworkingRequst.h"
#import "MainCimemaViewController.h"



@interface MainTableViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    
    CinemaComplaintView *_complaintView;
    BOOL _loadADImge;
    
}

@property (nonatomic,strong) CinemaSliderView *cinemaHeaderView;
@property(nonatomic,strong) NSMutableArray *slidersArr;  // 轮播图
@property(nonatomic,strong)  Cinema *cinemaMsg;   // 影院信息
@property(nonatomic,strong) NSMutableArray *filmsArr;   // 电影
@property(nonatomic,strong) MBProgressHUD *HUD;
@property(nonatomic,assign) NSInteger nowPlayingFilmcurrentPage;
@property(nonatomic, assign) NSInteger willPlayFilmCurrentPage;
@property(nonatomic, assign) BOOL shouldScroll;

@property(nonatomic, strong) void(^notificationBlock)(void);

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    _loadADImge = NO;
    
    
    [self addNotification];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shouldScroll = YES;
    __weak typeof(self) weakSelf = self;
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadWillPlaFilm];
        [weakSelf loadNowPlayingFilm];
    }];
    [self.mainTableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreNowPlayingFilm) name:ZYCimemaUpdataMoreNowPlayingFilmNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreWillPayFilm) name:ZYCimemaUpdataMoreWillPlayFilmNotification object:nil];
    
    
   

    
    //添加 选择影院之后 的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataNotification:) name:SelectedCimemaUpdataMainCimemaDataNotification object:nil];
}

- (void)addNotification {
    
    __weak typeof(self) weakSlef = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:ItemScrollToTopNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSlef.shouldScroll = [note.object boolValue];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);

    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

- (NSMutableArray *)filmsArr {
    if (!_filmsArr) {
        _filmsArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _filmsArr;
}
- (NSMutableArray *)slidersArr {
    if (!_slidersArr) {
        _slidersArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _slidersArr;
}

- (MainTableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[MainTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        [_mainTableView registerClass:[CustomCell class] forCellReuseIdentifier:@"cell"];
    }
    return _mainTableView;
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.VC = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenHeight - 49 - 64;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;

    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(mainTableViewController:scrollViewDidScroll:)]) {
            [self.delegate mainTableViewController:self scrollViewDidScroll:scrollView];
        }
    }
    
    if(offsetY >= CinemaViewControllerHeaderScrollImageH - 64){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TabViewScrollToTopNotification object:@(YES)];
        
        self.shouldScroll = NO;
        
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TabViewScrollToTopNotification object:@(NO)];
        
        
    }
    
    
    if(self.shouldScroll == NO){
        
        [scrollView setContentOffset:CGPointMake(0, CinemaViewControllerHeaderScrollImageH - 64)];
    }
    
    
}

#pragma mark -- 网络请求

- (void)refreshDataNotification:(NSNotification *)notification {
    self.notificationBlock = ^{
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:SelectedCimemaUpdataOtherDataNotification object:nil userInfo:nil];
    };
    
    [self loadNowPlayingFilm];
}

/**
 加载正在热映
 */
- (void)loadNowPlayingFilm {
    self.nowPlayingFilmcurrentPage = 0;
    [self loadCinemaMessage];
}

/**
 加载更多正在热映
 */
- (void)loadMoreNowPlayingFilm {
    self.nowPlayingFilmcurrentPage++;
    [self loadCinemaMessage];
}



/**
 加载即将上映
 */
- (void)loadWillPlaFilm {
    self.willPlayFilmCurrentPage = 0;
    [self loadWillPlayFilmMessage];

}

/**
 加载更多即将上映
 */
- (void)loadMoreWillPayFilm {
    self.willPlayFilmCurrentPage++;
    [self loadWillPlayFilmMessage];

}


- (void)loadWillPlayFilmMessage {
    //Api/Common/upComing
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@Api/Common/upComing",BASE_URL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
        parameters[@"group_id"] = ApiGroup_ID;
    }
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.willPlayFilmCurrentPage);
    parameters[@"size"] = @(10);
    NSLog(@"%@",parameters);
    
    
    [[ZYCinemaMainNetworkingRequst shareInstance] loadWillPlayFilmWithURL:urlStr withParameters:parameters completeHandle:^(BOOL success, NSString *error) {
        
        if (success) {
            //发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:ZYCimemaUpdataWillPlayFilmNotification object:nil userInfo:nil];
        }else {
            [BZProgressHUD showToView:weakSelf.view text:error time:1];
        }
        
    }];
    
}

- (void)loadCinemaMessage
{
    if (self.HUD == nil) {
        self.HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        self.HUD.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.HUD];
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonCinemaURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
        parameters[@"group_id"] = ApiGroup_ID;
    }
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.nowPlayingFilmcurrentPage);
    parameters[@"size"] = @(10);
    NSLog(@"%@",parameters);
    
    [[ZYCinemaMainNetworkingRequst shareInstance] loadNowPlayingFilmWithURL:urlStr withParameters:parameters completeHandle:^(BOOL success, NSString *error) {
        
        [self.HUD hideAnimated:YES];
        
        if ([self.mainTableView.mj_header isRefreshing]) {
            [self.mainTableView.mj_header endRefreshing];
        }
        
        if (success) {//成功

            self.cinemaMsg = [ZYCinemaMainNetworkingRequst shareInstance].cinemaMsg;
            self.slidersArr = [ZYCinemaMainNetworkingRequst shareInstance].sliderImgsArray;
            
            MainCimemaViewController *parentVC = (MainCimemaViewController *)self.parentViewController;
            parentVC.segemetnControl.hidden = NO;

            // 下载本影院的图
            if (_loadADImge) {
                
            } else {
                
                [(AppDelegate *)[UIApplication sharedApplication].delegate getAdvertisingImageWithCinemaID:self.cinemaMsg.id];
                _loadADImge = YES;
            }
            
            //加载头部滚动图片
            [self initCinemaViewCtlUI];
            [_cinemaHeaderView configCellWithArray:self.slidersArr cinemaMsg:self.cinemaMsg];
            
            
                if (error.length != 0) {
                    [BZProgressHUD showToView:self.view text:error time:1];
                }
            
            
            [self.mainTableView reloadData];
            
            if (weakSelf.notificationBlock) {
                weakSelf.notificationBlock();
                weakSelf.notificationBlock = nil;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZYCimemaUpdataNowPlayingFilmNotification object:nil userInfo:nil];
            
        } else {//失败
            [BZProgressHUD showProgressToView:self.view text:error time:1];
        }
        
    }];
    
   }


- (void)initCinemaViewCtlUI
{
    _cinemaHeaderView = [[CinemaSliderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CinemaViewControllerHeaderScrollImageH)];
    _cinemaHeaderView.adView.autoScrollTimeInterval = 5;
//    _cinemaHeaderView.delegate = self;
    // NSMutableArray *arr = [NSMutableArray array];
    // [_cinemaHeaderView configCellWithArray:arr];
    self.mainTableView.tableHeaderView = _cinemaHeaderView;
    
}


- (void)endRefresh
{
    if (self.mainTableView.mj_header.isRefreshing) {
        [self.mainTableView.mj_header endRefreshing];
    }
//    if (self.mainTableView.mj_footer.isRefreshing) {
//        [self.mainTableView.mj_footer endRefreshing];
//    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
