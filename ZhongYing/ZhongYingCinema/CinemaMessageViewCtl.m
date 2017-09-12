//
//  CinemaMessageViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaMessageViewCtl.h"
#import "CinemaMsgTableViewCell.h"
#import "CinemaMsgSliderView.h"
#import "CinemaMsgFooterView.h"
#import "CinemaCommentViewCtl.h"
#import "LoginViewController.h"
#import "CinemaMapViewCtl.h"
//#import "CinemaViewController.h"
#import "InformationViewController.h"
@interface CinemaMessageViewCtl ()<UITableViewDelegate,UITableViewDataSource,CinemaMsgFooterViewDelegate,CinemaMsgSliderDelegate>
{
    CinemaMsgSliderView *_headerView;
    CinemaMsgFooterView *_footerView;
    MBProgressHUD *_HUD;
    MBProgressHUD *_concernHUD;
}
@end

@implementation CinemaMessageViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"影院详情";
    self.message = [NSMutableDictionary dictionaryWithDictionary:[self.cinema toDictionary]];
    [self initCinemaMsgViewCtlUI];
    [self loadCinemaDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    if (_headerView != nil) {
        /** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
        [_headerView.adView adjustWhenControllerViewWillAppera];
    }
}

#pragma mark - help Methods
- (void)loadCinemaDetails
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonCinemaDetailURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }
    parameters[@"lng"] = ApiLngStr;
    parameters[@"lat"] = ApiLatStr;
    parameters[@"group_id"] = ApiGroup_ID;
    parameters[@"cinema_id"] = self.cinema.id;
    NSLog(@"cinema_id == %@",self.cinema.id);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"CinemaMessage >>>>>>>> %@",dataBack);
        self.message = [NSMutableDictionary dictionaryWithDictionary:dataBack[@"content"]];
        [self.sliders addObjectsFromArray:dataBack[@"content"][@"sliders"]];
        for (int i = 0; i < self.sliders.count; i ++) {
            [self.sliders replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,self.sliders[i]]];
        }
        [_headerView configCellWithArray:self.sliders CinemaName:self.message[@"title"]];
        [_footerView configViewWithIs_star:[self.message[@"is_star"] boolValue]];
        [self.cinemaMsgTableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)initCinemaMsgViewCtlUI
{
    _headerView = [[CinemaMsgSliderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    //NSMutableArray *arr = [NSMutableArray arrayWithArray:self.sliders];
    [_headerView configCellWithArray:self.sliders CinemaName:self.message[@"title"]];
    _headerView.delegate = self;
    
    self.cinemaMsgTableView.tableHeaderView = _headerView;
    
    _footerView = [[CinemaMsgFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -200 -140 -64)];
    _footerView.delegate = self;
    self.cinemaMsgTableView.tableFooterView = _footerView;
}

- (void)concernCinema
{
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
    }else{
        _concernHUD = [FanShuToolClass createMBProgressHUDWithText:@"" target:self];
        [self.view addSubview:_concernHUD];
        
        NSString *urlStr;
        if (!_footerView.concernBtn.selected) {
            urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserStarURL];
            _concernHUD.labelText = @"关注中...";
        }else{
            urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserUnstarURL];
            _concernHUD.labelText = @"取消关注中...";
        }
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        parameters[@"cinema_id"] = self.cinema.id;
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            NSLog(@"getUserStar >>>>>>>> %@",dataBack);
            if ([dataBack[@"code"] integerValue] == 0) {
                if (!_footerView.concernBtn.selected) {
                    [self showHudMessage:@"关注成功"];
                    [self reloadCinemaData];
                }else{
                    [self showHudMessage:@"取消关注成功"];
                }
                _footerView.concernBtn.selected = !_footerView.concernBtn.selected;
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
            [_concernHUD hideAnimated:YES];
        } failure:^(NSError *error) {
            [self showHudMessage:@"连接服务器失败!"];
            [_concernHUD hideAnimated:YES];
        }];
    }
}

- (void)reloadCinemaData
{
    [[NSUserDefaults standardUserDefaults] setObject:self.cinema.id forKey:@"Apicinema_id"];// 影院ID
    //登录后刷新影院模块
//    UINavigationController *nav = self.tabBarController.viewControllers[0];
//    CinemaViewController *cinema = [nav.viewControllers objectAtIndex:0];
//    cinema.currentPage = 0;
//    [cinema.cinemaTableView removeFromSuperview];
//    cinema.cinemaTableView = nil;
//    cinema.HUD = nil;
//    [cinema.slidersArr removeAllObjects];
//    [cinema.filmsArr removeAllObjects];
//    cinema.cinemaMsg = nil;
    
//    UINavigationController *newNavigationController1 = self.tabBarController.viewControllers[1];
//    InformationViewController *informationCtl = [newNavigationController1.viewControllers objectAtIndex:0];
//    if (informationCtl.informationArr.count != 0) {
//        informationCtl.currentPage = 0;
//        [informationCtl.informationTableView removeFromSuperview];
//        informationCtl.informationTableView = nil;
//        [informationCtl.informationArr removeAllObjects];
//        [informationCtl.slidersArr removeAllObjects];
//    }
}

#pragma mark - 懒加载
- (UITableView *)cinemaMsgTableView
{
    if (_cinemaMsgTableView == nil) {
        _cinemaMsgTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped target:self];
        [_cinemaMsgTableView registerClass:[CinemaMsgTableViewCell class] forCellReuseIdentifier:@"CinemaMsgTableViewCell"];
        [self.view addSubview:_cinemaMsgTableView];
    }
    return _cinemaMsgTableView;
}

- (NSMutableArray *)sliders
{
    if (_sliders == nil) {
        _sliders = [NSMutableArray array];
    }
    return _sliders;
}

#pragma mark - CinemaMsgSliderDelegate
- (void)gotoChangeCinemaEvent
{
    [[NSUserDefaults standardUserDefaults] setObject:self.cinema.id forKey:@"Apicinema_id"];// 影院ID
    [[NSUserDefaults standardUserDefaults] synchronize ];
    
    //发送通知重新加载 影院 资讯 商城的 所有数据
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectedCimemaUpdataMainCimemaDataNotification object:nil];
    
    [(ZYTabBarController *)self.tabBarController popToCinemaViewController];
}

#pragma mark - CinemaMsgFooterViewDelegate
- (void)jumpToCinemaMsgFooterViewEvents:(CinemaMsgFooterViewEvents)event
{
    if (event == CinemaMsgConcernEvent) {
        NSLog(@"关注");
        [self concernCinema];
        
    }else if (event == CinemaMsgCommentEvent){
        NSLog(@"我要评论");
        if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [login setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:login animated:YES];
        }else{
            CinemaCommentViewCtl *cinemaComment = [[CinemaCommentViewCtl alloc] init];
            cinemaComment.id = self.cinema.id;
            cinemaComment.name = self.message[@"title"];
            cinemaComment.type = @"影院评论";
            [cinemaComment setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:cinemaComment animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSLog(@"地图");
        CinemaMapViewCtl *cinemaMap = [[CinemaMapViewCtl alloc] init];
        cinemaMap.hidesBottomBarWhenPushed = YES;
        cinemaMap.name = self.message[@"title"];
        cinemaMap.location = CLLocationCoordinate2DMake([self.message[@"lat"] doubleValue], [self.message[@"lng"] doubleValue]);
        [self.navigationController pushViewController:cinemaMap animated:YES];
    }else{
        NSLog(@"电话");
        NSString *str1 = self.message[@"phone"];
        NSString *numbers = @"0123456789";
        NSMutableString *str2 = [NSMutableString string];
        for (int i = 0; i < [str1 length]; i ++) {
            if ([numbers containsString:[str1 substringWithRange:NSMakeRange(i, 1)]]) {
                [str2 appendString:[str1 substringWithRange:NSMakeRange(i, 1)]];
            }
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",str2];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
            
            if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
            }
        }else{
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CinemaMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CinemaMsgTableViewCell"];
    if (indexPath.row == 1) {
        cell.messageLb.font = [UIFont systemFontOfSize:16];
        cell.iconImg.image = [UIImage imageNamed:@"cinema_phone"];
        cell.messageLb.text = self.message[@"phone"];
    }else{
        cell.messageLb.font = [UIFont systemFontOfSize:16];
        cell.iconImg.image = [UIImage imageNamed:@"cinema_address"];
        cell.messageLb.text = self.message[@"address"];
    }
    return cell;
}

@end
