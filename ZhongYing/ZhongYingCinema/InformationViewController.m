//
//  InformationViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/15.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "InformationViewController.h"
#import "informationSliderView.h"
#import "InfoTableViewCell.h"
#import "NewsInfoViewController.h"
#import "MovieInfoViewController.h"
#import "BoxOfficeViewController.h"
#import "InfoDetailsViewCtl.h"
#import "News.h"

@interface InformationViewController ()<UITableViewDataSource,UITableViewDelegate,infoSliderViewDelegate>
{
    informationSliderView *_infoSliderView;
    MBProgressHUD *_HUD;
}
/**
 导航条的背景视图
 */
@property (nonatomic, weak) UIImageView *navigationBarBackgroundView;

/** 导航栏背景的透明度 */
@property (nonatomic, assign) CGFloat lastAlpha;

/** 状态栏黄色背景视图 */
@property (nonatomic, strong) UIView *statusBarbackgroundView;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
    self.lastAlpha = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentPage = 0;
    self.navigationItem.title = @"";
    
    [self setupStatusBarBackground];
}

- (void)setupStatusBarBackground {
    UIView *statusBarbackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:statusBarbackgroundView];
    statusBarbackgroundView.backgroundColor = Color(252, 186, 0, 1.0);
    self.statusBarbackgroundView = statusBarbackgroundView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
        
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if (self.informationArr.count == 0) {
        _HUD = nil;
        [self loadNewsMessage];
    }
    if (_infoSliderView != nil) {
        /** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
        [_infoSliderView.adView adjustWhenControllerViewWillAppera];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFromApn"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 0;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFromApn"];
    }
    
    
    //设置透明的导航栏
    self.navigationController.navigationBar.translucent = YES;
    
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBarBackgroundView.alpha = self.lastAlpha;
    

}

- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    
    self.navigationBarBackgroundView.alpha = 1;
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    [self.navigationController.navigationBar setShadowImage:nil];
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
        
        if (self.currentPage == 0) {
            [self.informationArr removeAllObjects];
            [self.slidersArr removeAllObjects];
            [self.informationTableView.mj_header endRefreshing];
        }else {
            [self.slidersArr removeAllObjects];
            [self.informationTableView.mj_footer endRefreshing];
        }
        [self.slidersArr addObjectsFromArray:content[@"sliders"]];
        
        for (int i = 0; i < self.slidersArr.count; i ++) {
            [self.slidersArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,self.slidersArr[i]]];
        }
        for (NSDictionary *dict in content[@"news"]) {
            NSError *error;
            News *news = [[News alloc] initWithDictionary:dict error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            [self.informationArr addObject:news];
        }
        
        [self initInfoViewCtlUI];
        [self.informationTableView reloadData];
        [_HUD hideAnimated:YES];
        [self.view bringSubviewToFront:self.statusBarbackgroundView];

    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        if (self.currentPage == 0) {
            [self.informationTableView.mj_header endRefreshing];
        }else {
            [self.informationTableView.mj_footer endRefreshing];
        }
        [_HUD hideAnimated:YES];
    }];
}

- (void)initInfoViewCtlUI
{
    _infoSliderView = [[informationSliderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,InformationViewControllerTableViewHeaderImgHeight)];//CinemaViewControllerHeaderScrollImageH
    [_infoSliderView configCellWithArray:self.slidersArr];
    _infoSliderView.delegate = self;
    self.informationTableView.tableHeaderView = _infoSliderView;
}

- (void)addRefreshView
{
    __weak InformationViewController *info = self;
    self.informationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        info.currentPage = 0;
        [info loadNewsMessage];
    }];
    
    self.informationTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        info.currentPage ++;
        [info loadNewsMessage];
    }];
    //[self hideRefreshViewsubViews:self.informationTableView];
}

#pragma mark - 懒加载
- (UITableView *)informationTableView
{
    if (_informationTableView == nil) {
        _informationTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0,20, ScreenWidth, ScreenHeight-49-20) style:UITableViewStyleGrouped target:self];
        [_informationTableView registerClass:[InfoTableViewCell class] forCellReuseIdentifier:@"informationTableViewCell"];
        _informationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addRefreshView];
        [self.view addSubview:_informationTableView];
    }
    return _informationTableView;
}

- (NSMutableArray *)informationArr
{
    if (_informationArr == nil) {
        _informationArr = [[NSMutableArray alloc] init];
    }
    return _informationArr;
}

- (NSMutableArray *)slidersArr
{
    if (_slidersArr == nil) {
        _slidersArr = [[NSMutableArray alloc] init];
    }
    return _slidersArr;
}

#pragma mark - infoSliderViewDelegate
- (void)infoSliderViewDelegateWithTag:(NSInteger)tag
{
    if (tag == NewsInfoEvent) {// 新闻资讯
        NSLog(@"新闻资讯");
        NewsInfoViewController *newsInfo = [[NewsInfoViewController alloc] init];
        [newsInfo setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newsInfo animated:YES];
        
    }else if (tag == MovieInfoEvent){// 影片资讯
        NSLog(@"影片资讯");
        MovieInfoViewController *movieInfo = [[MovieInfoViewController alloc] init];
        [movieInfo setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:movieInfo animated:YES];
        
    }else if (tag == BoxOfficeEvnet){// 票房
        NSLog(@"票房");
        BoxOfficeViewController *boxOffice = [[BoxOfficeViewController alloc] init];
        [boxOffice setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:boxOffice animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return InformationViewControllerTableViewCellHeight * heightFloat;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    InfoDetailsViewCtl *infoDetails = [[InfoDetailsViewCtl alloc] init];
    News *news = self.informationArr[indexPath.row];
    news.rate = [NSString stringWithFormat:@"%zd",[cell.pageviewsBtn.titleLabel.text integerValue] +1];
    news.comment = cell.commentsBtn.titleLabel.text;
    infoDetails.news = news;
    infoDetails.commentBlock = ^void(NSInteger commentNum){
        [cell.commentsBtn setTitle:[NSString stringWithFormat:@"%zd",commentNum] forState:UIControlStateNormal];
    };
    
    infoDetails.rateBlock = ^void(NSInteger rateNum){
        [cell.pageviewsBtn setTitle:[NSString stringWithFormat:@"%zd",rateNum] forState:UIControlStateNormal];
    };
    [infoDetails setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:infoDetails animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.informationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"informationTableViewCell"];
    News *news = self.informationArr[indexPath.row];
    [cell configCellWithModel:news];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y;
    
    CGFloat alpha = (1 / (CinemaViewControllerHeaderScrollImageH - 64)) * offset;
    
//    self.navigationBarBackgroundView.alpha = alpha;
//    self.lastAlpha = alpha;
}


@end
