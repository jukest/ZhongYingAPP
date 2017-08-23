//
//  MovieInfoViewController.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieInfoViewController.h"
#import "InfoTableViewCell.h"
#import "InfoDetailsViewCtl.h"

@interface MovieInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *movieInfoArr;
@property(nonatomic,assign) NSInteger currentPage;

@end

@implementation MovieInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"影片资讯";
    
    self.currentPage = 0;
    [self loadNewsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help Methods
- (void)loadNewsList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonNewsListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }
    parameters[@"lng"] = ApiLngStr;
    parameters[@"lat"] = ApiLatStr;
    parameters[@"group_id"] = ApiGroup_ID;
    parameters[@"category"] = @(2);
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSDictionary *content = dataBack[@"content"];
        
        if (self.currentPage == 0) {
            [self.movieInfoArr removeAllObjects];
            [self.movieInfoTableView.mj_header endRefreshing];
        }else {
            [self.movieInfoTableView.mj_footer endRefreshing];
        }
        
        for (NSDictionary *dict in content[@"list"]) {
            NSError *error;
            News *news = [[News alloc] initWithDictionary:dict error:&error];
            [self.movieInfoArr addObject:news];
        }
        [self initNewsInfoViewCtlUI];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)initNewsInfoViewCtlUI
{
    [self.movieInfoTableView reloadData];
}

- (void)addRefreshView
{
    __weak MovieInfoViewController *movieInfo = self;
    self.movieInfoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        movieInfo.currentPage = 0;
        [movieInfo loadNewsList];
    }];
    
    self.movieInfoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        movieInfo.currentPage ++;
        [movieInfo loadNewsList];
    }];
    //[self hideRefreshViewsubViews:self.movieInfoTableView];
}

#pragma mark - 懒加载
- (UITableView *)movieInfoTableView
{
    if (_movieInfoTableView == nil) {
        _movieInfoTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_movieInfoTableView registerClass:[InfoTableViewCell class] forCellReuseIdentifier:@"MovieInfoTableViewCell"];
        [self addRefreshView];
        [self.view addSubview:_movieInfoTableView];
    }
    return _movieInfoTableView;
}

- (NSMutableArray *)movieInfoArr
{
    if (_movieInfoArr == nil) {
        _movieInfoArr = [NSMutableArray array];
    }
    return _movieInfoArr;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movieInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieInfoTableViewCell"];
    News *new = self.movieInfoArr[indexPath.row];
    [cell configCellWithModel:new];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115 * heightFloat;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    InfoDetailsViewCtl *infoDetails = [[InfoDetailsViewCtl alloc] init];
    News *news = self.movieInfoArr[indexPath.row];
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

@end
