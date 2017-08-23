//
//  EvaluateViewCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/17.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "EvaluateViewCtl.h"
#import "EvaluateCell.h"
#import "CinemaCommentViewCtl.h"
#import "Evaluate.h"

@interface EvaluateViewCtl ()<UITableViewDelegate,UITableViewDataSource,EvaluateCellDelegate>
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *evaluateList;
@property(nonatomic,assign) NSInteger currentPage;

@end

@implementation EvaluateViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"待评价";
    // Do any additional setup after loading the view.
    // [self.evaluateTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidEvaluated:) name:@"Evaluate" object:nil];
    
    self.currentPage = 0;
    [self loadWaitCommentsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UITableView *)evaluateTableView
{
    if (_evaluateTableView == nil) {
        _evaluateTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_evaluateTableView registerClass:[EvaluateCell class] forCellReuseIdentifier:@"EvaluateCell"];
        [self addRefreshView];
        [self.view addSubview:_evaluateTableView];
    }
    return _evaluateTableView;
}

- (NSMutableArray *)evaluateList
{
    if (_evaluateList == nil) {
        _evaluateList = [NSMutableArray array];
    }
    return _evaluateList;
}

#pragma mark - Evaluate
- (void)movieDidEvaluated:(NSNotification *)note
{
    NSLog(@"%@",note);
    [self.evaluateList removeObject:note.object];
    [self.evaluateTableView reloadData];
}

#pragma mark - help Methods
- (void)loadWaitCommentsList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserWaitingCommentsListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        [self endRefresh];
        NSLog(@"getWaitCommentsList>>>>>>>>>>>>%@",dataBack);
        if (self.currentPage == 0) {
            [self.evaluateList removeAllObjects];
        }
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"data"]) {
                NSError *error;
                Evaluate *evaluate = [[Evaluate alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"WaitCommentsList_error=%@",error);
                }
                evaluate.cinema_name = content[@"cinema_name"];
                [self.evaluateList addObject:evaluate];
            }
            [self.evaluateTableView reloadData];
        }else if ([dataBack[@"code"] intValue] == 46005){
            if (self.currentPage == 0) {
                [self showHudMessage:@"你没有待评价影片!"];
            }else{
                [self showHudMessage:@"没有更多了!"];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [_HUD hide:YES];
        [self endRefresh];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)addRefreshView
{
    __weak EvaluateViewCtl *evaluate = self;
    self.evaluateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        evaluate.currentPage = 0;
        [evaluate loadWaitCommentsList];
    }];
    
    self.evaluateTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        evaluate.currentPage ++;
        [evaluate loadWaitCommentsList];
    }];
    //[self hideRefreshViewsubViews:self.evaluateTableView];
}

- (void)endRefresh
{
    if (self.evaluateTableView.mj_header.isRefreshing) {
        [self.evaluateTableView.mj_header endRefreshing];
    }
    if (self.evaluateTableView.mj_footer.isRefreshing) {
        [self.evaluateTableView.mj_footer endRefreshing];
    }
}

#pragma mark - EvaluateCellDelegate
- (void)gotoMarkEventWithIndexPath:(NSIndexPath *)indexPath
{
    Evaluate *evaluate = self.evaluateList[indexPath.row];
    CinemaCommentViewCtl *cinemaComment = [[CinemaCommentViewCtl alloc] init];
    cinemaComment.name = evaluate.name;
    cinemaComment.type = @"待评价评论";
    cinemaComment.evaluate = evaluate;
    cinemaComment.id = [NSString stringWithFormat:@"%zd",evaluate.movie_id];
    [cinemaComment setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cinemaComment animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
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
    return self.evaluateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Evaluate *evaluate = self.evaluateList[indexPath.row];
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    [cell configCellWithModel:evaluate];
    cell.delegate = self;
    return cell;
}

@end
