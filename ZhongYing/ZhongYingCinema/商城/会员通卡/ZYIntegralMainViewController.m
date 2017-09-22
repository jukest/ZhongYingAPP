//
//  ZYIntegralMainViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYIntegralMainViewController.h"
#import "MainTableView.h"
#import "ZYMallIntegralMainCell.h"
#import "informationSliderView.h"
#import "ZYMallIntegralNetworkingRequst.h"


@interface ZYIntegralMainViewController ()<UITableViewDelegate,UITableViewDataSource,infoSliderViewDelegate>
@property (nonatomic, strong) MainTableView *mainTableView;


/**
 我的积分加载的当前页
 */
@property(nonatomic,assign) NSInteger myIntegralCurrentPage;


/**
 兑换记录加载的当前页
 */
@property (nonatomic, assign) NSInteger exchangeRecordsCurrentPage;



/**
 资讯首页轮播图
 */
@property (nonatomic, strong) informationSliderView *infoSliderView;


@property (nonatomic, strong) NSMutableArray *sliderImagesArray;

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


/**
 是不是首页
 */
@property (nonatomic, assign) BOOL isMain;
@end

@implementation ZYIntegralMainViewController

- (instancetype)initWithIsMain:(BOOL)isMain {
    self = [super init];
    if (self) {
       
        self.isMain = isMain;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shouldScroll = YES;
   
    if (self.isMain) {
        self.navigationBarBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
        self.lastAlpha = 0;
    }
    
    
  
    
    [self setUI];
    [self addNotification];
    
    __weak typeof(self) weakSelf = self;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMyIntegralData];
        [weakSelf loadExchangeRecordsData];
        [weakSelf loadCommonSlider];
    }];
    [self.mainTableView.mj_header beginRefreshing];;
    

}

#pragma mark -- 添加通知
- (void)addNotification {
    
    __weak typeof(self) weakSlef = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:ZYIntegralScrollBaseViewScrollToTopNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSlef.shouldScroll = [note.object boolValue];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreMyIntegralData) name:@"UpdataMoreMyIntegralNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreExchangeRecordsData) name:@"UpdataMoreExchangeRecordNotification" object:nil];
    
    //添加 选择影院之后 的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:SelectedCimemaUpdataOtherDataNotification object:nil];
    
    
    //添加 由 ZYMallViewController 控制器发来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavigationBarAlpha:) name:@"ZYallViewControllerDidSegemetnNotification" object:nil];
 
    
    
}


#pragma mark --通知
- (void)setNavigationBarAlpha:(NSNotification *)notifica {
    NSDictionary *obj = (NSDictionary *)notifica.object;
    
    NSInteger index = [obj[@"index"] integerValue];
    
    if (index == 1) {
        
        self.navigationBarBackgroundView.alpha = self.lastAlpha;
        [self.navigationBarBackgroundView layoutSubviews];
    }
}





#pragma mark -- 初始化

- (void)setUI{
    self.mainTableView.tableHeaderView = self.infoSliderView;
}



#pragma mark -- 懒加载
- (NSMutableArray *)sliderImagesArray {
    if (!_sliderImagesArray) {
        _sliderImagesArray = [NSMutableArray array];
    }
    return _sliderImagesArray;
}

- (informationSliderView *)infoSliderView {
    if (!_infoSliderView) {
        _infoSliderView = [[informationSliderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,InformationViewControllerTableViewHeaderImgHeight)];//CinemaViewControllerHeaderScrollImageH
        
        _infoSliderView.delegate = self;
        
    }
    return _infoSliderView;
}

- (MainTableView *)mainTableView {
    
    if (!_mainTableView) {
        CGFloat y = 0;
        CGFloat height = ScreenHeight - 49;
        if (!self.isMain) {
            y = 64;
            height = ScreenHeight - 64;
        }
        _mainTableView = [[MainTableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, height) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
//        [_mainTableView registerClass:[ZYMallIntegralMainCell class] forCellReuseIdentifier:@"ZYMallIntegralMainCell"];
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
    
}

#pragma mark --UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isMain) {
        return ScreenHeight - 49 - 64;
    } else {
        return ScreenHeight - 64;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMallIntegralMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZYMallIntegralMainCell"];
    if (!cell) {
        cell = [[ZYMallIntegralMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZYMallIntegralMainCell" withIsMain:self.isMain];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if ([ZYMallIntegralNetworkingRequst shareInstance].balance != nil) {
        
        cell.title = [NSString stringWithFormat:@"我的积分:%@",[ZYMallIntegralNetworkingRequst shareInstance].balance];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat offset = scrollView.contentOffset.y;
    
    CGFloat alpha = (1 / (InformationViewControllerTableViewHeaderImgHeight - 64)) * offset;
    
    self.navigationBarBackgroundView.alpha = alpha;
    self.lastAlpha = alpha;
    
    CGFloat maxOffsetY = InformationViewControllerTableViewHeaderImgHeight - 64;
    
    if (!self.isMain) {
        maxOffsetY = InformationViewControllerTableViewHeaderImgHeight;
    }
    
    
    if(offsetY >= maxOffsetY){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYIntegralMianTableViewScrollToTopNotification object:@(YES)];
        
        self.shouldScroll = NO;
        
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYIntegralMianTableViewScrollToTopNotification object:@(NO)];
    }
    
    if(self.shouldScroll == NO){
        
        [scrollView setContentOffset:CGPointMake(0, maxOffsetY)];
    }
}


#pragma mark -- 网络请求

- (void)loadMyIntegralData {
    self.myIntegralCurrentPage = 0;
    [self loadMyIntegral];
    
}

- (void)loadMoreMyIntegralData {
    self.myIntegralCurrentPage++;
    [self loadMyIntegral];
    
}

- (void)loadExchangeRecordsData {
    self.exchangeRecordsCurrentPage = 0;
    [self loadExchangeRecords];
}

- (void)loadMoreExchangeRecordsData {
    self.exchangeRecordsCurrentPage++;
    [self loadExchangeRecords];
    
}

//加载我的积分
- (void)loadMyIntegral {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserShoplistURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.myIntegralCurrentPage);
    parameters[@"size"] = @(10);
    [[ZYMallIntegralNetworkingRequst shareInstance] loadMyIntegralWithURL:urlStr withParameters:parameters completeHandle:^(BOOL success, NSString *error) {
        
        [self.mainTableView.mj_header endRefreshing];
        if (success) {//
            
            [self.mainTableView reloadData];
            //通知 我的积分控制器 更新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataMyIntegralNotification" object:nil];
            
            
        } else {
            [self showHudMessage:error];
            
        }
        
    }];
    
}

//加载兑换记录
- (void)loadExchangeRecords {
    
//    UpdataExchangeRecordNotification
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserExchangeRecordURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(self.exchangeRecordsCurrentPage);
    parameters[@"size"] = @(10);
    [[ZYMallIntegralNetworkingRequst shareInstance] loadExchangeRecordsWithURL:urlStr withParameters:parameters completeHandle:^(BOOL success, NSString *error) {
        if (success) {
            //通知 兑换记录控制器 更新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataExchangeRecordNotification" object:nil];
        } else {
            [self showHudMessage:error];
        }
    }];
}

- (void)loadCommonSlider {
    __weak typeof (self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonSlider];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"group_id"] = ApiGroup_ID;
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
    }
    parameters[@"type"] = @3;
    
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        
        
        NSLog(@"getSliderImages>>>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            
            [weakSelf.sliderImagesArray removeAllObjects];
            
            NSDictionary *content = dataBack[@"content"];
            for (NSString *str in content[@"sliders"]) {
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",Image_URL,str];
                
                [weakSelf.sliderImagesArray addObject:urlStr];
                
            }
            //刷新轮播图
            [weakSelf.infoSliderView configCellWithArray:weakSelf.sliderImagesArray];
            
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
        [self showHudMessage:@"连接服务器失败!"];
    }];
    
    
}


@end
