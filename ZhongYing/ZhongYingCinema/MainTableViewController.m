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
@property(nonatomic,assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL shouldScroll;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    _loadADImge = NO;
    [self loadCinemaMessage];
    [self addNotification];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shouldScroll = YES;
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self loadCinemaMessage];
    }];
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
        
//        self.shouldScroll = YES;
        
    }
    
    
    if(self.shouldScroll == NO){
        
        [scrollView setContentOffset:CGPointMake(0, CinemaViewControllerHeaderScrollImageH - 64)];
    }
    
    
}


- (void)loadCinemaMessage
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        _HUD.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_HUD];
    }
    
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
    parameters[@"page"] = @(_currentPage);
    parameters[@"size"] = @(10);
    NSLog(@"%@",parameters);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getCinemaMessage >>>>>> %@",dataBack);
        
        if (self.mainTableView != nil) {
            [self endRefresh];
        }
        if (_currentPage == 0) {
            [self.filmsArr removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            [self.slidersArr removeAllObjects];
            
            NSDictionary *content = dataBack[@"content"];
            if (![content[@"sliders"] isEqual:[NSNull null]]) {
                [self.slidersArr addObjectsFromArray:content[@"sliders"]];
            }
            
            NSError *cinema_error;
            self.cinemaMsg = [[Cinema alloc] initWithDictionary:content[@"cinema"] error:&cinema_error];
            self.cinemaMsg.id = content[@"cinema"][@"cinema_id"];
            
            // 下载本影院的图
            if (_loadADImge) {
                
            } else {
                
                [(AppDelegate *)[UIApplication sharedApplication].delegate getAdvertisingImageWithCinemaID:self.cinemaMsg.id];
                _loadADImge = YES;
            }
            
            if (cinema_error) {
                NSLog(@"cinema_error=%@",cinema_error);
            }
            NSError *error;
            for (NSDictionary *hot_film in content[@"hot_films"]) {
                HotFilm *hotFilm = [[HotFilm alloc] initWithDictionary:hot_film error:&error];
                [self.filmsArr addObject:hotFilm];
            
            }
            
           
            
            for (int i = 0; i < self.slidersArr.count; i ++) {
                [self.slidersArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,self.slidersArr[i]]];
            }
            //加载头部滚动图片
            [self initCinemaViewCtlUI];
            [_cinemaHeaderView configCellWithArray:self.slidersArr cinemaMsg:self.cinemaMsg];
            
            [self.mainTableView reloadData];
            
            
            if (self.loadDataDelegate != nil) {
                if ([self.loadDataDelegate respondsToSelector:@selector(mainTableViewControllerFinshLoadData:dataArray:withCinemaMsg:)]) {
                    [self.loadDataDelegate mainTableViewControllerFinshLoadData:self dataArray:self.filmsArr withCinemaMsg:self.cinemaMsg];
                }
            }
            
            
            
        }else if ([dataBack[@"code"] intValue] == 46005){
            if (_currentPage == 0) {
                [self showHudMessage:@"没有电影信息!"];
            }else{
                [self showHudMessage:@"没有更多了!"];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        if (self.mainTableView != nil) {
            [self endRefresh];
        }
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
    }];
}


- (void)initCinemaViewCtlUI
{
    _cinemaHeaderView = [[CinemaSliderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CinemaViewControllerHeaderScrollImageH)];
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
