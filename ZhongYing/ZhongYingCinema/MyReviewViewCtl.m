//
//  MyReviewViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/6.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyReviewViewCtl.h"
#import "MyReviewCell.h"
#import "MovieDetailsViewCtl.h"
#import "MyFilmComment.h"

@interface MyReviewViewCtl ()<UITableViewDelegate,UITableViewDataSource,MyReviewCellDelegate>
{
    NSArray *_reviews;
    MBProgressHUD *_HUD;
}
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray *FilmCommentList;
@property(nonatomic,strong) Cinema *cinemaMsg;

@end

@implementation MyReviewViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的影评";
    // Do any additional setup after loading the view.

    self.currentPage = 0;
    [self loadMyFilmCommentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help Methods
- (void)loadMyFilmCommentList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMyFilmCommentListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        [self endRefresh];
        NSLog(@"getMyFilmCommentList = %@",dataBack);
        if (self.currentPage == 0) {
            [self.FilmCommentList removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                MyFilmComment *comment = [[MyFilmComment alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"MyFilmComment_error = %@",error);
                }
                comment.cinema_name = content[@"cinema_name"];
                [self.FilmCommentList addObject:comment];
            }
            self.cinemaMsg = [[Cinema alloc] init];
            self.cinemaMsg.title = content[@"cinema_name"];
            
            [self.reviewTableView reloadData];
        }else if ([dataBack[@"code"] intValue] == 46005){
            if (self.currentPage == 0) {
                [self showHudMessage:@"你还没有影评信息!"];
            }else{
                [self showHudMessage:@"没有更多了!"];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self endRefresh];
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)addRefreshView
{
    __weak MyReviewViewCtl *review = self;
    self.reviewTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        review.currentPage = 0;
        [review loadMyFilmCommentList];
    }];
    
    self.reviewTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        review.currentPage ++;
        [review loadMyFilmCommentList];
    }];
    //[self hideRefreshViewsubViews:self.reviewTableView];
}

- (void)endRefresh
{
    if (self.reviewTableView.mj_header.isRefreshing) {
        [self.reviewTableView.mj_header endRefreshing];
    }
    if (self.reviewTableView.mj_footer.isRefreshing) {
        [self.reviewTableView.mj_footer endRefreshing];
    }
}

#pragma mark - 懒加载
- (UITableView *)reviewTableView
{
    if (_reviewTableView == nil) {
        _reviewTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_reviewTableView registerClass:[MyReviewCell class] forCellReuseIdentifier:@"MyReviewCell"];
        [self addRefreshView];
        [self.view addSubview:_reviewTableView];
    }
    return _reviewTableView;
}

- (NSMutableArray *)FilmCommentList
{
    if (_FilmCommentList == nil) {
        _FilmCommentList = [NSMutableArray array];
    }
    return _FilmCommentList;
}

#pragma mark - MyReviewCellDelegate
- (void)MovieViewDidSelectedIndexPath:(NSIndexPath *)indexPath
{
    MyFilmComment *comment = self.FilmCommentList[indexPath.row];
    MovieDetailsViewCtl *movieDetails = [[MovieDetailsViewCtl alloc] init];
    HotFilm *film = [[HotFilm alloc] init];
    film.id = [NSString stringWithFormat:@"%@",comment.movie_id];
    film.name = comment.name;
    film.cover = comment.cover;
    film.trailer = @"";
    movieDetails.type = @"海报";
    movieDetails.hotFilm = film;
    movieDetails.cinemaMsg = self.cinemaMsg;
    movieDetails.isApn = NO;
    [movieDetails setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:movieDetails animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFilmComment *filmComment = self.FilmCommentList[indexPath.row];
    CGSize reviewSize = [FanShuToolClass createString:filmComment.content font:[UIFont systemFontOfSize:16] lineSpacing:2 maxSize:CGSizeMake(ScreenWidth -12 -25, ScreenHeight)];
    return reviewSize.height +165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FilmCommentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFilmComment *comment = self.FilmCommentList[indexPath.row];
    MyReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyReviewCell"];
    [cell configCellWithModel:comment];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

@end
