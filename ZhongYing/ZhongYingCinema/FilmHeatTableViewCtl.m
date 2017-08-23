//
//  FilmHeatTableViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "FilmHeatTableViewCtl.h"
#import "BoxOfficeTableViewCell.h"
#import "BoxOfficeHeaderView.h"
#import "FilmHeatTableViewCell.h"
#import "HeatFilm.h"

@interface FilmHeatTableViewCtl ()
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *heatList;
@end

@implementation FilmHeatTableViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[FilmHeatTableViewCell class] forCellReuseIdentifier:@"FilmHeatTableViewCell"];
    self.tableView.bounces = NO;
    [self loadFilmHeatList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - help Methods
- (void)loadFilmHeatList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonFilmHeatListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"group_id"] = ApiGroup_ID;
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
    }
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getFilmHeatList>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                HeatFilm *film = [[HeatFilm alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"heatList_error=%@",error);
                }
                [self.heatList addObject:film];
            }
        }else if ([dataBack[@"code"] integerValue] == 46005){
            [self showHudMessage:@"没有更多了"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self.tableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)heatList
{
    if (_heatList == nil) {
        _heatList = [NSMutableArray array];
    }
    return _heatList;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.heatList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titles = @[@"影片",@"影评",@"排行"];
    UIView *whiteView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 10) backgroundColor:[UIColor whiteColor]];
    BoxOfficeHeaderView *headerView = [[BoxOfficeHeaderView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50) titles:titles];
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 60) backgroundColor:[UIColor whiteColor]];
    [view addSubview:whiteView];
    [view addSubview:headerView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rankImgs = @[@"1st_heat",@"2nd_heat",@"3rd_heat"];
    HeatFilm *film = self.heatList[indexPath.row];
    FilmHeatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilmHeatTableViewCell" forIndexPath:indexPath];
    [cell configCellWithModel:film];
    if (indexPath.row < 3) {
        cell.historyBoxOfficeLb.hidden = YES;
        cell.rankImg.hidden = NO;
        cell.rankImg.image = [UIImage imageNamed:rankImgs[indexPath.row]];
    }else{
        cell.historyBoxOfficeLb.hidden = NO;
        cell.rankImg.hidden = YES;
        cell.historyBoxOfficeLb.text = [NSString stringWithFormat:@"%zd",indexPath.row +1];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
