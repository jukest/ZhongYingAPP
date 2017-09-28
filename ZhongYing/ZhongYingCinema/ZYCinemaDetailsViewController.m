//
//  ZYCinemaDetailsViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/19.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYCinemaDetailsViewController.h"

#import "CinemaDtlTableViewCell.h"
#import "CinemaDtlHeaderView.h"
#import "ViewPackagesView.h"
#import "CinemaMessageViewCtl.h"
#import "ConfirmPackageOrderViewCtl.h"
#import "SelectSeatViewCtl.h"
#import "Goods.h"
#import "Schedule.h"
#import "UIImageView+WebCache.h"
#import "CinemaMapViewCtl.h"
#import "LoginViewController.h"

#import "WXSegmentView.h"
#import "CBSegmentView.h"
#import "WXScheduleDataManager.h"

@interface ZYCinemaDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,CinemaMsgViewDelegate,MovieSliderViewDelegate,CinemaDtlTavleViewCellDelegate,ViewPackageViewDelegate>
{
    CinemaDtlHeaderView *_headerView;
    ViewPackagesView *_footerView;
    UIView *_lineView;
    NSInteger _index;
    MBProgressHUD *_HUD;
    BOOL _once;
    BOOL _loadCinemaFinish;
    BOOL _loadGoodsFinish;
    BOOL _isOnShow;
}

@property(nonatomic,strong) NSMutableArray *goodsList;
@property(nonatomic,strong) NSString *movie_id;



/**
 电影的排片计划 模型数组
 */
@property (nonatomic, strong) NSMutableArray *filmPlayPlanModels;


@property (nonatomic, strong) WXSegmentView *sliderSegmentView;

/**
 安排的日期数组
 */
@property (nonatomic, strong) NSMutableArray *playDates;

@property (nonatomic, assign) NSInteger selectedPlayDateIndex;

@property (nonatomic, strong) NSString *serviceMoney;
@end

@implementation ZYCinemaDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.cinemaMsg.title;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _index = 0;
    _once = YES;
    _loadGoodsFinish = NO;
    _loadCinemaFinish = NO;
    _isOnShow = YES;
    self.selectedPlayDateIndex = 0;
    
    self.movie_id = self.film.id;
    
    [self loadCinemaPlay];
    [self loadServiceMoney];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
}

#pragma mark - Help Methods
- (void)loadCinemaPlay
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
        [_HUD showAnimated:YES];

    }else{
        [_HUD showAnimated:YES];
        [self.view bringSubviewToFront:_HUD];
    }
    

    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonCinemaPlayURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"group_id"] = ApiGroup_ID;
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
    }
    parameters[@"movie_id"] = self.movie_id;
    
    NSLog(@"parameters = %@",parameters);
    
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if (_cinemaDetailsTableView != nil && _cinemaDetailsTableView.mj_header.isRefreshing) {
            [_cinemaDetailsTableView.mj_header endRefreshing];
        }
        NSLog(@"getCinemaPlay >>>>>>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            _loadCinemaFinish = YES;
            [self.filmPlayPlanModels removeAllObjects];

            [self.filmsArr removeAllObjects];
            
            NSDictionary *content = dataBack[@"content"];
            if ([content[@"list"] count] == 0 || [content[@"film"] count] == 0) {
                [self showHudMessage:@"此影片已结束上映"];
                [_HUD hideAnimated:YES];
                _isOnShow = NO;
                [self.cinemaDetailsTableView removeFromSuperview];
                //[self initCinemaDetailUI];
                //[self showFilmMessage];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return ;
            }
            
            //再加商品
            [self loadGoods];

            
            //电影 播放 计划
            NSArray *playPlanModels = [Schedule wx_objectArrayWithKeyValuesArray:content[@"list"]];
            [self.filmPlayPlanModels addObjectsFromArray:playPlanModels];
            [self numberOfTotalDayForFilms];
            [self.sliderSegmentView setTitleArray:self.playDates withStyle:WXSegmentStyleSlider];
//            [self schedulesWithSelectedPlayDateIndex:self.selectedPlayDateIndex];

            //影院信息
            NSError *cinema_error;
            self.cinemaMsg = [[Cinema alloc] initWithDictionary:content[@"detail"] error:&cinema_error];
            if (cinema_error) {
                NSLog(@"cinema_error=%@",cinema_error);
            }
            
            // 电影 部数
            for (NSInteger i = 0; i < [content[@"film"] count]; i ++) {
                NSError *film_error;
                HotFilm *film = [[HotFilm alloc] initWithDictionary:content[@"film"][i] error:&film_error];
                if (film_error) {
                    NSLog(@"film_error=%@",film_error);
                }
                if ([film.id isEqualToString:self.movie_id]) {
                    self.indexPath = i;
                }
                [self.filmsArr addObject:film];
            }
                if (_once) {//显示头部
                    _headerView = [[CinemaDtlHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 287) CinemaMsg:self.cinemaMsg filmsArr:self.filmsArr index:self.indexPath];
                    _headerView.cinemaMsgView.delegate = self;
                    _headerView.movieSliderView.delegate = self;
                    self.cinemaDetailsTableView.tableHeaderView = _headerView;
                    [_headerView.movieSliderView.pageFlowView scrollToPage:self.indexPath];
                    _once = NO;
                }
                
                [self showFilmMessage];
                if (self.goodsList.count != 0) {
                    [self initCinemaDetailUI];
                }
            
        }else if([dataBack[@"code"] integerValue] == 46005){
            [self.filmPlayPlanModels removeAllObjects];
            [self showHudMessage:@"此影片已结束上映"];
            _isOnShow = NO;
            
            //取消当前网络
            [[ZhongYingConnect shareInstance] cancel];
            
            [self.cinemaDetailsTableView removeFromSuperview];
         
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self.cinemaDetailsTableView reloadData];
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        _isOnShow = NO;
        _loadCinemaFinish = NO;
        if (self.cinemaDetailsTableView.mj_header.isRefreshing) {
            [self.cinemaDetailsTableView.mj_header endRefreshing];
        }
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
    }];
}

- (void)loadServiceMoney{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiGetPoundageOld];
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
        NSLog(@"getGoods>>>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            
            NSDictionary *content = dataBack[@"content"];
            
            self.serviceMoney = content[@"poundage"];
        
            [self.cinemaDetailsTableView reloadData];
            
        }else{
            
            [self showHudMessage:dataBack[@"message"]];
            
        }
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
    }];
}


- (void)loadGoods
{
    if (!_isOnShow) {
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonGoodsURL];
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
        NSLog(@"getGoods>>>>>>>>>>>>>>%@",dataBack);
        _loadGoodsFinish = YES;
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"goods"]) {
                
                Goods *goods = [Goods mj_objectWithKeyValues:dict];
                
                [self.goodsList addObject:goods];
            }
            
            [self showFilmMessage];
            if (self.goodsList.count != 0) {
                [self initCinemaDetailUI];
            }
            [self.cinemaDetailsTableView reloadData];
            
            
//            if (_loadCinemaFinish&&_loadGoodsFinish) {
//                if (_once) {
//                    
//                    _headerView = [[CinemaDtlHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 287) CinemaMsg:self.cinemaMsg filmsArr:self.filmsArr index:self.indexPath];
//                    _headerView.cinemaMsgView.delegate = self;
//                    _headerView.movieSliderView.delegate = self;
//                    self.cinemaDetailsTableView.tableHeaderView = _headerView;
//                    [_headerView.movieSliderView.pageFlowView scrollToPage:self.indexPath];
//                    _once = NO;
//                }
//                
//                [self showFilmMessage];
//                if (self.goodsList.count != 0) {
//                    [self initCinemaDetailUI];
//                }
//                [self.cinemaDetailsTableView reloadData];
//            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        _loadGoodsFinish = NO;
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)initCinemaDetailUI
{
    _footerView = [[ViewPackagesView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 63 + 66 * self.goodsList.count) packages:self.goodsList];
    _footerView.delegate = self;
    self.cinemaDetailsTableView.tableFooterView = _footerView;
    [self.cinemaDetailsTableView reloadData];
}

- (void)showFilmMessage
{
    HotFilm *hotFile = self.filmsArr[self.indexPath];
    [_headerView.movieSliderView.pageFlowView.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,hotFile.cover]] placeholderImage:[UIImage imageNamed:@""]];
    NSString *name = hotFile.name;
    NSString *mark = [NSString stringWithFormat:@"%.1f分",hotFile.stars];
    _headerView.movieSliderView.nameLb.text = [NSString stringWithFormat:@"%@ %@",name,mark];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_headerView.movieSliderView.nameLb.text];
    NSRange range = [_headerView.movieSliderView.nameLb.text rangeOfString:mark];
    [str addAttribute:NSForegroundColorAttributeName value:Color(252, 186, 0, 1.0) range:range];
    _headerView.movieSliderView.nameLb.attributedText = str;
}

- (void)addRefreshView
{
    __weak ZYCinemaDetailsViewController *cinema = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.cinemaDetailsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [cinema loadCinemaPlay];
        
    }];
    
}

#pragma mark - 懒加载

- (WXSegmentView *)sliderSegmentView {
    if (!_sliderSegmentView) {
        __weak typeof(self) weakSelf = self;
        _sliderSegmentView = [[WXSegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [_sliderSegmentView setTitleArray:self.playDates withStyle:WXSegmentStyleSlider];
        _sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
            weakSelf.selectedPlayDateIndex = x;
            [weakSelf.cinemaDetailsTableView reloadData];
        };
    }
    return _sliderSegmentView;
}

- (NSMutableArray *)playDates {
    if (!_playDates) {
        _playDates = [NSMutableArray array];
    }
    return _playDates;
}

- (NSMutableArray *)filmPlayPlanModels {
    if (!_filmPlayPlanModels) {
        _filmPlayPlanModels = [NSMutableArray array];
    }
    return _filmPlayPlanModels;
}

- (UITableView *)cinemaDetailsTableView
{
    if (_cinemaDetailsTableView == nil) {
        _cinemaDetailsTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_cinemaDetailsTableView registerClass:[CinemaDtlTableViewCell class] forCellReuseIdentifier:@"CinemaDtlTableViewCell"];
        //[self addRefreshView];
        [self.view addSubview:_cinemaDetailsTableView];
    }
    return _cinemaDetailsTableView;
}

- (NSMutableArray *)goodsList
{
    if (_goodsList == nil) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

- (NSMutableArray *)filmsArr
{
    if (_filmsArr == nil) {
        _filmsArr = [NSMutableArray array];
    }
    return _filmsArr;
}

#pragma mark - Views Handles
-(void)btnDidClicked:(UIButton *)btn
{
    if(btn.tag == 38) {
        _index = 0;
    }else if(btn.tag == 39){
        _index = 1;
    }else if(btn.tag == 40){
        _index = 2;
    }
    [self.cinemaDetailsTableView reloadData];
}

#pragma mark - CinemaMsgViewDelegate
- (void)jumpToCinemaMsgViewEvent:(CinemaMsgViewEvents)event
{
    if (event == CinemaDetailsEvent) {
        CinemaMessageViewCtl *cinemaMessage = [[CinemaMessageViewCtl alloc] init];
        Cinema *cinema = self.cinemaMsg;
        cinema.id = self.cinemaMsg.id;
        cinemaMessage.cinema = cinema;
        [cinemaMessage setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cinemaMessage animated:YES];
    }else if (event == CinemaMapEvent){
        NSLog(@"地图");
        CinemaMapViewCtl *cinemaMap = [[CinemaMapViewCtl alloc] init];
        cinemaMap.name = self.cinemaMsg.title;
        cinemaMap.location = CLLocationCoordinate2DMake([self.cinemaMsg.lat doubleValue], [self.cinemaMsg.lng doubleValue]);
        [cinemaMap setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cinemaMap animated:YES];
    }
}

#pragma mark - MovieSliderViewDelegate
- (void)MovieDidChanged:(NSInteger)index
{
    NSLog(@"电影切换到%zd",index);
    if (self.indexPath != index) {
        self.indexPath = index;
        HotFilm *hotFilm = self.filmsArr[index];
        self.movie_id = hotFilm.id;
        [self loadCinemaPlay];
    }
}

#pragma mark - CinemaDtlTavleViewCellDelegate
- (void)gotoBuyTicketEvent
{
    NSLog(@"去购票");
    SelectSeatViewCtl *selectSeat = [[SelectSeatViewCtl alloc] init];
    [selectSeat setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:selectSeat animated:YES];
}

#pragma mark - ViewPackageViewDelegate
- (void)selectBtnDidClickedIndexpath:(NSIndexPath *)indexPath
{
    NSLog(@"去确认订单");
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
        [(ZYNavigationController *)self.navigationController showLoginViewController];
    }else{
        ConfirmPackageOrderViewCtl *confirmOrder = [[ConfirmPackageOrderViewCtl alloc] init];
        Goods *goods = self.goodsList[indexPath.row];
        confirmOrder.goods = goods;
        confirmOrder.cinemaMsg = self.cinemaMsg;
        [confirmOrder setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:confirmOrder animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
    
        if (self.playDates.count != 0) {
            return 47;
        }
        
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return self.sliderSegmentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
    }else{
 
        NSArray *schedules = [self schedulesWithSelectedPlayDateIndex:self.selectedPlayDateIndex];
        Schedule *schedule = schedules[indexPath.row];
        HotFilm *hotFile = self.filmsArr[self.indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SelectSeatViewCtl *selectSeat = [[SelectSeatViewCtl alloc] init];
        selectSeat.schedule = schedule;
        selectSeat.hotFilm = hotFile;
        selectSeat.goodsList = self.goodsList;
        selectSeat.index = self.selectedPlayDateIndex;
        selectSeat.cinemaMsg = self.cinemaMsg;
        [selectSeat setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:selectSeat animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *schedules = [self schedulesWithSelectedPlayDateIndex:self.selectedPlayDateIndex];
    
    return schedules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CinemaDtlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CinemaDtlTableViewCell"];
     NSArray *schedules = [self schedulesWithSelectedPlayDateIndex:self.selectedPlayDateIndex];
    Schedule *schedule = schedules[indexPath.row];
    
    [cell configCellWithModel:schedule];
    cell.remainingLb.text = [NSString stringWithFormat:@"含服务费:￥%@",self.serviceMoney];
    cell.delegate = self;
    return cell;
}



#pragma mark --对排片计划模型数组进行处理 

//计算 总共售卖 多少天
- (NSInteger)numberOfTotalDayForFilms {
    
    
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithCapacity:self.filmPlayPlanModels.count];
    for (Schedule *schedule in self.filmPlayPlanModels) {
        [resultDict setObject:@(schedule.date) forKey:@(schedule.date)];
    }
    NSArray *resultArray = resultDict.allValues;

    //排序
    resultArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    //获取模型
    NSMutableArray *resultModels = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < resultArray.count; i++) {
        
        NSInteger startTime = [resultArray[i] integerValue];
        for (int j = 0; j<self.filmPlayPlanModels.count; j++) {
            Schedule *schedule = self.filmPlayPlanModels[j];
            if (schedule.date == startTime) {
                [resultModels addObject:schedule];
            }
        }
    }
    
    [self.playDates removeAllObjects];

    for (int i = 0; i < resultModels.count; i++) {
        Schedule *schedule = resultModels[i];
        [self.playDates addObject:[[WXScheduleDataManager shareScheduleDataManager] showInfoWithDate:[NSDate dateWithTimeIntervalSince1970:schedule.start_time]]];
    }
    
    //去重
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *string in self.playDates) {
        if (![result containsObject:string]) {
            [result addObject:string];
        }
    }
    self.playDates = result;
    NSLog(@"时间安排:%@",self.playDates);
    
//    NSMutableDictionary *resultDict1 = [[NSMutableDictionary alloc] initWithCapacity:self.playDates.count];
//    for (int i = 0; i<self.playDates.count; i++) {
//        [resultDict1 setObject:self.playDates[i] forKey:self.playDates[i]];
//    }
//    
//    NSArray *resultArray1 = resultDict1.allKeys;
//    self.playDates = [resultArray1 mutableCopy];


    return self.playDates.count;
}

- (NSArray *)schedulesWithSelectedPlayDateIndex:(NSInteger)selectedIndex {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.filmPlayPlanModels.count; i++) {
        Schedule *schedule = self.filmPlayPlanModels[i];
        if ([self.playDates[selectedIndex] isEqualToString:schedule.showInfo]) {
            [array addObject:schedule];
        }
        
    }
    
    
    return array;
}


@end
