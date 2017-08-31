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

@interface ZYInformationMaintViewController ()<UITableViewDelegate,UITableViewDataSource,infoSliderViewDelegate,UINavigationControllerDelegate>
{
    informationSliderView *_infoSliderView;
    MBProgressHUD *_HUD;
}
@property (nonatomic,strong)MainTableView *mainTableView;

@property(nonatomic,assign) NSInteger currentPage;

@property(nonatomic,strong) NSMutableArray *slidersArr;

@property (nonatomic, assign) BOOL shouldScroll;


/**
 导航条的背景视图
 */
@property (nonatomic, weak) UIImageView *navigationBarBackgroundView;

/** 导航栏背景的透明度 */
@property (nonatomic, assign) CGFloat lastAlpha;

/** 状态栏黄色背景视图 */
@property (nonatomic, strong) UIView *statusBarbackgroundView;


@end

@implementation ZYInformationMaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self addNotification];
    [self setupUI];
    [self loadNewsMessage];
    
    self.navigationController.delegate = self;
    

}

#pragma mark -- 初始化

- (void)setupUI{
//    [self setNavigationbar];
    [self setupStatusBarBackground];

}

- (void)setNavigationbar {
    self.navigationBarBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
    self.lastAlpha = 0;
    self.currentPage = 0;
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
    
    
//    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //隐藏导航栏
    
    
    
//    if (self.informationArr.count == 0) {
//        _HUD = nil;
//        [self loadNewsMessage];
//    }
    if (_infoSliderView != nil) {
        /** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
        [_infoSliderView.adView adjustWhenControllerViewWillAppera];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFromApn"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 0;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFromApn"];
    }
    
    
    //设置透明的导航栏
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationBarBackgroundView.alpha = self.lastAlpha;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    
//    self.navigationBarBackgroundView.alpha = 1;
//    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
//    [self.navigationController.navigationBar setShadowImage:nil];
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

- (void)addNotification {
    
    __weak typeof(self) weakSlef = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:ZYInformationScrollBaseScrollToTopNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSlef.shouldScroll = [note.object boolValue];
    }];
}

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






#pragma mark - help Methods
- (void)loadNewsMessage
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonNewsURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }
    parameters[@"lng"] = ApiLngStr;
    parameters[@"lat"] = ApiLatStr;
    parameters[@"group_id"] = ApiGroup_ID;
    parameters[@"page"] = @(_currentPage);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getNewsMessage >>>>>>>>>> %@",dataBack);
        NSDictionary *content = dataBack[@"content"];
        
//        if (self.currentPage == 0) {
//            [self.informationArr removeAllObjects];
//            [self.slidersArr removeAllObjects];
//            [self.informationTableView.mj_header endRefreshing];
//        }else {
//            [self.slidersArr removeAllObjects];
//            [self.informationTableView.mj_footer endRefreshing];
//        }
        [self.slidersArr addObjectsFromArray:content[@"sliders"]];
        
        for (int i = 0; i < self.slidersArr.count; i ++) {
            [self.slidersArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,self.slidersArr[i]]];
        }
//        for (NSDictionary *dict in content[@"news"]) {
//            NSError *error;
//            News *news = [[News alloc] initWithDictionary:dict error:&error];
//            if (error) {
//                NSLog(@"%@",error);
//            }
//            [self.informationArr addObject:news];
//        }
        
        [self initInfoViewCtlUI];
//        [self.informationTableView reloadData];
        [_HUD hideAnimated:YES];
//        [self.view bringSubviewToFront:self.statusBarbackgroundView];
        
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        if (self.currentPage == 0) {
//            [self.informationTableView.mj_header endRefreshing];
        }else {
//            [self.informationTableView.mj_footer endRefreshing];
        }
        [_HUD hideAnimated:YES];
    }];
}

- (void)initInfoViewCtlUI
{
    _infoSliderView = [[informationSliderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,InformationViewControllerTableViewHeaderImgHeight)];//CinemaViewControllerHeaderScrollImageH
    [_infoSliderView configCellWithArray:self.slidersArr];
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
