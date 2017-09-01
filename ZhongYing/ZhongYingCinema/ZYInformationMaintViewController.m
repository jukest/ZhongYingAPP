//
//  ZYInformationMaintViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationMaintViewController.h"
#import "MainTableView.h"
#import "InformatiomMainCell.h"
#import "informationSliderView.h"
#import "ZYInformantionMainNetworingRequst.h"

@interface ZYInformationMaintViewController ()<UITableViewDelegate,UITableViewDataSource,infoSliderViewDelegate,UINavigationControllerDelegate>
{
    informationSliderView *_infoSliderView;
    MBProgressHUD *_HUD;
}

/**
    主tableView
 */
@property (nonatomic,strong)MainTableView *mainTableView;


/**
 新闻加载的当前页
 */
@property(nonatomic,assign) NSInteger newsCurrentPage;


/**
 票房加载的当前页
 */
@property (nonatomic, assign) NSInteger boxOfficeCurrentPage;


/**
 轮播图数组
 */
@property(nonatomic,strong) NSMutableArray *slidersArr;


/**
 当前tableview是否滚动
 */
@property (nonatomic, assign) BOOL shouldScroll;


/**
 导航条的背景视图
 */
@property (nonatomic, weak) UIImageView *navigationBarBackgroundView;

/** 导航栏背景的透明度 */
@property (nonatomic, assign) CGFloat lastAlpha;

/** 状态栏黄色背景视图 */
@property (nonatomic, strong) UIView *statusBarbackgroundView;


/**
 网络请求次数
 */
@property (nonatomic, assign) NSInteger requstCount;

@end

@implementation ZYInformationMaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shouldScroll = YES;
    
    self.newsCurrentPage = 0;
    self.boxOfficeCurrentPage = 0;
    self.requstCount = 0;
    
    [self addNotification];
    [self setupUI];
    
    [BZProgressHUD showProgressToView:self.view];
    //加载 新闻资讯 和 票房
    [self loadNewsMessage];
    [self loadBoxOfficeData];
    
    self.navigationController.delegate = self;
    

}

#pragma mark -- 添加通知
- (void)addNotification {
    
    __weak typeof(self) weakSlef = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:ZYInformationScrollBaseScrollToTopNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSlef.shouldScroll = [note.object boolValue];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreNewsData) name:ZYInformationUpdataMoreNewsDataNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreBoxOfficeData) name:ZYInformationUpdataMoreBoxOfficeNotification object:nil];
    
    
}

#pragma mark -- 初始化

- (void)setupUI{
    [self addRefresh];

    [self setupStatusBarBackground];

}

- (void)endRefresh{
    if ([self.mainTableView.mj_header isRefreshing]) {
        [self.mainTableView.mj_header endRefreshing];
    }
    
    
}

- (void)addRefresh{
    __weak typeof (self) weakSelf = self;
    self.mainTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.newsCurrentPage = 0;
        weakSelf.boxOfficeCurrentPage = 0;
        [weakSelf loadNewsMessage];
        [weakSelf loadBoxOfficeData];
    }];

}

- (void)setNavigationbar {
    self.navigationBarBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
    self.lastAlpha = 0;
    self.navigationItem.title = @"";
}


- (void)setupStatusBarBackground {
    UIView *statusBarbackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:statusBarbackgroundView];
    statusBarbackgroundView.backgroundColor = Color(252, 186, 0, 1.0);
    self.statusBarbackgroundView = statusBarbackgroundView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    if (_infoSliderView != nil) {
        /** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
        [_infoSliderView.adView adjustWhenControllerViewWillAppera];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFromApn"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 0;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFromApn"];
    }
    
    
}





#pragma mark -- 懒加载

- (MainTableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[MainTableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 49 - 20) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        [_mainTableView registerClass:[InformatiomMainCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
    
}

- (NSMutableArray *)slidersArr
{
    if (_slidersArr == nil) {
        _slidersArr = [[NSMutableArray alloc] init];
    }
    return _slidersArr;
}



#pragma mark -- UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenHeight - 20 - 49;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformatiomMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}



#pragma mark -- UITableViewDelegate



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    
    if(offsetY >= InformationViewControllerTableViewHeaderImgHeight){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYInformationTabViewScrollToTopNotification object:@(YES)];
        
        self.shouldScroll = NO;
        
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYInformationTabViewScrollToTopNotification object:@(NO)];
    }
    
    if(self.shouldScroll == NO){
        
        [scrollView setContentOffset:CGPointMake(0, InformationViewControllerTableViewHeaderImgHeight)];
    }
}

#pragma mark -- 通知相关

- (void)loadMoreNewsData {
    self.newsCurrentPage++;
    [self loadNewsMessage];
    
}

- (void)loadMoreBoxOfficeData {
    self.boxOfficeCurrentPage++;
    [self loadBoxOfficeData];
    
}


#pragma mark - help Methods

- (void)loadNewsMessage
{
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonNewsURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }
    parameters[@"lng"] = ApiLngStr;
    parameters[@"lat"] = ApiLatStr;
    parameters[@"group_id"] = ApiGroup_ID;
    parameters[@"page"] = @(self.newsCurrentPage);
    
    [[ZYInformantionMainNetworingRequst shareInstance] loadNewsWithURL:urlStr withParameters:parameters completeHandle:^(BOOL success, NSString *error) {
        
        [weakSelf endRefresh];
        weakSelf.requstCount += 1;
        if (weakSelf.requstCount == 2) {
            [BZProgressHUD hiddenFromeView:self.view];
        }
        if (success) {
            
            [weakSelf.mainTableView reloadData];
            [weakSelf initInfoViewCtlUI];
            
            //发送通知 更新新闻资讯 数据
            [[NSNotificationCenter defaultCenter] postNotificationName:ZYInformationUpdataNewsDataNotification object:nil];

        } else {
            [BZProgressHUD showProgressToView:self.view text:error time:1];
        }
        
        
        
    }];
}


- (void)loadBoxOfficeData {
    
    __weak typeof(self) weakSelf = self;

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserCommonTicketListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"group_id"] = ApiGroup_ID;
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
    }
    parameters[@"page"] = @(self.boxOfficeCurrentPage);
    parameters[@"size"] = @(10);
    [[ZYInformantionMainNetworingRequst shareInstance] loadBoxOfficWithURL:urlStr withParameters:parameters completeHandle:^(BOOL success, NSString *error) {
        
        [weakSelf endRefresh];
        
        weakSelf.requstCount += 1;
        if (weakSelf.requstCount == 2) {
            [BZProgressHUD hiddenFromeView:self.view];
        }
        
        if (success) {
            
            [weakSelf.mainTableView reloadData];
            
            //发送通知 更新新闻资讯 数据
            [[NSNotificationCenter defaultCenter] postNotificationName:ZYInformationUpdataBoxOfficeNotification object:nil];
            
        } else {
            [BZProgressHUD showProgressToView:self.view text:error time:1];

        }

        
    }];
    
}


- (void)initInfoViewCtlUI
{
    _infoSliderView = [[informationSliderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,InformationViewControllerTableViewHeaderImgHeight)];//CinemaViewControllerHeaderScrollImageH
    
    [_infoSliderView configCellWithArray:[ZYInformantionMainNetworingRequst shareInstance].sliderImgsArray];
    _infoSliderView.delegate = self;
    self.mainTableView.tableHeaderView = _infoSliderView;
}


#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
