//
//  MoreCinemaViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MoreCinemaViewCtl.h"
#import "MoreCinemaTableViewCell.h"
#import "CinemaMessageViewCtl.h"
#import "Cinema.h"

@interface MoreCinemaViewCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *cinemaList;

@end

@implementation MoreCinemaViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.cinemaType isEqualToString:@"关注影院"]) {
        self.navigationItem.title = @"关注影院";
    }else{
        self.navigationItem.title = @"影院详情";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.MoreCinemaTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.cinemaList removeAllObjects];
        [self loadCinemaList];
    }];
    
    
    [self loadCinemaList];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);

    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods
- (void)loadCinemaList
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([self.cinemaType isEqualToString:@"更多影院"]) {
        urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonCinemaListURL];
        
        parameters[@"group_id"] = ApiGroup_ID;
    }else if ([self.cinemaType isEqualToString:@"关注影院"]){
        urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserStarListURL];
    }
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }
    parameters[@"lng"] = ApiLngStr;
    parameters[@"lat"] = ApiLatStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        
        if (self.MoreCinemaTableView != nil) {
            [self.MoreCinemaTableView.mj_header endRefreshing];
        }
        
        NSLog(@"cinemaList >>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            
            NSArray *cinemas;
            if ([self.cinemaType isEqualToString:@"更多影院"]) {
                cinemas = dataBack[@"content"][@"cinemas"];
            }else if ([self.cinemaType isEqualToString:@"关注影院"]){
                cinemas = dataBack[@"content"][@"list"];
            }
            
            for (NSDictionary *dict in cinemas) {
                NSError *error;
                Cinema *cinema = [[Cinema alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"%@",error);
                }
                [self.cinemaList addObject:cinema];
            }
        }else if ([dataBack[@"code"] integerValue] == 46005){
            [self showHudMessage:@"您还没有关注影院哦~"];
        }
        [self.MoreCinemaTableView reloadData];
        [_HUD hideAnimated:NO];
    } failure:^(NSError *error) {
        if (self.MoreCinemaTableView != nil) {
            [self.MoreCinemaTableView.mj_header endRefreshing];
        }
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
    }];
}

#pragma mark - 懒加载
- (UITableView *)MoreCinemaTableView
{
    if (_MoreCinemaTableView == nil) {
        _MoreCinemaTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_MoreCinemaTableView registerClass:[MoreCinemaTableViewCell class] forCellReuseIdentifier:@"MoreCinemaTableViewCell"];
        [self.view addSubview:_MoreCinemaTableView];
    }
    return _MoreCinemaTableView;
}

- (NSMutableArray *)cinemaList
{
    if (_cinemaList == nil) {
        _cinemaList = [NSMutableArray array];
    }
    return _cinemaList;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cinemaList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCinemaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCinemaTableViewCell"];
    Cinema *cinema = self.cinemaList[indexPath.row];
    [cell configCellWithModel:cinema];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70 * widthFloat;
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
    Cinema *cinema = self.cinemaList[indexPath.row];
    if ([self.cinemaType isEqualToString:@"更多影院"]) {
        CinemaMessageViewCtl *cinemaMsg = [[CinemaMessageViewCtl alloc] init];
        cinemaMsg.cinema = cinema;
        [cinemaMsg setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cinemaMsg animated:YES];
    }else if ([self.cinemaType isEqualToString:@"关注影院"]){
        [[NSUserDefaults standardUserDefaults] setObject:cinema.id forKey:@"Apicinema_id"];// 影院ID
        [(ZYTabBarController *)self.tabBarController popToCinemaViewController];
    }
}

@end
