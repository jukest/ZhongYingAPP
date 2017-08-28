//
//  CinemaDetailsViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaDetailsViewCtl.h"
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

@interface CinemaDetailsViewCtl ()<UITableViewDelegate,UITableViewDataSource,CinemaMsgViewDelegate,MovieSliderViewDelegate,CinemaDtlTavleViewCellDelegate,ViewPackageViewDelegate>
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
@property(nonatomic,strong) NSMutableArray *todaySchedule;  //!<< 今天时间表
@property(nonatomic,strong) NSMutableArray *afterSchedule;  //!<< 后天时间表
@property(nonatomic,strong) NSMutableArray *tomorrowSchedule;  //!<< 明天时间表
@property(nonatomic,strong) NSMutableArray *goodsList;
@property(nonatomic,strong) NSString *movie_id;

@end

@implementation CinemaDetailsViewCtl

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
    
    self.movie_id = self.film.id;
    
    [self loadCinemaPlay];
    [self loadGoods];
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
    }else{
        [_HUD show:YES];
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
        NSLog(@"parameters = %@",parameters);
    }
    parameters[@"movie_id"] = self.movie_id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if (_cinemaDetailsTableView != nil && _cinemaDetailsTableView.mj_header.isRefreshing) {
            [_cinemaDetailsTableView.mj_header endRefreshing];
        }
        NSLog(@"getCinemaPlay >>>>>>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            _loadCinemaFinish = YES;
            [self.todaySchedule removeAllObjects];
            [self.tomorrowSchedule removeAllObjects];
            [self.afterSchedule removeAllObjects];
            [self.filmsArr removeAllObjects];
            
            NSDictionary *content = dataBack[@"content"];
            if ([content[@"list"] count] == 0 || [content[@"film"] count] == 0) {
                [self showHudMessage:@"此影片已结束上映"];
                [_HUD hide:YES];
                _isOnShow = NO;
                [self.cinemaDetailsTableView removeFromSuperview];
                //[self initCinemaDetailUI];
                //[self showFilmMessage];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return ;
            }
            //获取 播放 计划
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Schedule *schedule = [[Schedule alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error = %@",error);
                }
                switch (schedule.time_type) {
                    case 1:
                        [self.todaySchedule addObject:schedule];
                        break;
                    case 2:
                        [self.tomorrowSchedule addObject:schedule];
                        break;
                    case 3:
                        [self.afterSchedule addObject:schedule];
                        break;
                    default:
                        break;
                }
            }
            
            //获取 影院 信息
            NSError *cinema_error;
            self.cinemaMsg = [[Cinema alloc] initWithDictionary:content[@"detail"] error:&cinema_error];
            if (cinema_error) {
                NSLog(@"cinema_error=%@",cinema_error);
            }
            
            //获取 电影 数量
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
            //[self initCinemaDetailUI];
            //记录当前展示 播放计划 的视图 的标志
            _index = 0;
            if (self.todaySchedule.count == 0) {
                _index = 1;
                if (self.tomorrowSchedule.count == 0) {
                    _index = 2;
                }
            }
            if (_loadCinemaFinish&&_loadGoodsFinish) {
                if (_once) {
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
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            [self.todaySchedule removeAllObjects];
            [self.tomorrowSchedule removeAllObjects];
            [self.afterSchedule removeAllObjects];
            [self showHudMessage:@"此影片已结束上映"];
            _isOnShow = NO;
            [self.cinemaDetailsTableView removeFromSuperview];
            //[self initCinemaDetailUI];
            //[self showFilmMessage];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self.cinemaDetailsTableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        _isOnShow = NO;
        _loadCinemaFinish = NO;
        if (self.cinemaDetailsTableView.mj_header.isRefreshing) {
            [self.cinemaDetailsTableView.mj_header endRefreshing];
        }
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
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
            if (_loadCinemaFinish&&_loadGoodsFinish) {
                if (_once) {
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
                [self.cinemaDetailsTableView reloadData];
            }
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
    __weak CinemaDetailsViewCtl *cinema = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.cinemaDetailsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [cinema loadCinemaPlay];
        
    }];
    
    //[self hideRefreshViewsubViews:self.cinemaDetailsTableView];
}

#pragma mark - 懒加载
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

- (NSMutableArray *)todaySchedule
{
    if (_todaySchedule == nil) {
        _todaySchedule = [NSMutableArray array];
    }
    return _todaySchedule;
}

- (NSMutableArray *)afterSchedule
{
    if (_afterSchedule == nil) {
        _afterSchedule = [NSMutableArray array];
    }
    return _afterSchedule;
}

- (NSMutableArray *)tomorrowSchedule
{
    if (_tomorrowSchedule == nil) {
        _tomorrowSchedule = [NSMutableArray array];
    }
    return _tomorrowSchedule;
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
        if (_index == 0) {
            if (self.todaySchedule.count != 0) {
                return 47;
            }
        }else if (_index == 1){
            if (self.tomorrowSchedule.count != 0) {
                return 47;
            }
        }else{
            if (self.afterSchedule.count != 0) {
                return 47;
            }
        }
        //return 47;
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *today = [NSString stringWithFormat:@"今天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
    NSString *tomorrow =  [NSString stringWithFormat:@"明天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] +86400] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
    NSString *after =  [NSString stringWithFormat:@"后天%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] +86400 * 2] transforTomyyyyMMddWithFormatter:@"MM月dd日"]];
    NSMutableArray *dates = [NSMutableArray array];
    if (self.todaySchedule.count != 0) {
        
        [dates addObject:today];
    }
    if (self.tomorrowSchedule.count != 0) {
        [dates addObject:tomorrow];
    }
    if (self.afterSchedule.count != 0) {
        [dates addObject:after];
    }
    
    UIView *datesView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 47) backgroundColor:[UIColor whiteColor]];
    for (int i = 0; i < dates.count; i ++) {
        UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(i * ScreenWidth / 3, 0, ScreenWidth / 3 -1, 45) title:dates[i] titleColor:Color(199, 0, 0, 1.0) target:self action:@selector(btnDidClicked:) tag:0];
        if ([dates[i] hasPrefix:@"后天"]) {
            btn.tag = 40;
        }
        if ([dates[i] hasPrefix:@"明天"]) {
            btn.tag = 39;
        }
        if ([dates[i] hasPrefix:@"今天"]) {
            btn.tag = 38;
        }
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:16 * widthFloat];
        
        if (btn.tag == _index +38) {
            [btn setTitleColor:Color(199, 0, 0, 1.0) forState:UIControlStateNormal];
            _lineView = [FanShuToolClass createViewWithFrame:CGRectMake(i * ScreenWidth / 3, 45, ScreenWidth / 3 -1, 2) backgroundColor:Color(201, 0, 0, 1.0)];
            [datesView addSubview:_lineView];
        }else {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        [datesView addSubview:btn];
    }
    return datesView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [login setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:login animated:YES];
    }else{
        Schedule *schedule;
        if (_index == 0) {
            schedule = self.todaySchedule[indexPath.row];
        }else if (_index == 1){
            schedule = self.tomorrowSchedule[indexPath.row];
        }else{
            schedule = self.afterSchedule[indexPath.row];
        }
        HotFilm *hotFile = self.filmsArr[self.indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SelectSeatViewCtl *selectSeat = [[SelectSeatViewCtl alloc] init];
        selectSeat.schedule = schedule;
        selectSeat.hotFilm = hotFile;
        selectSeat.goodsList = self.goodsList;
        selectSeat.index = _index;
        selectSeat.cinemaMsg = self.cinemaMsg;
        [selectSeat setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:selectSeat animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_index == 0) {
        return self.todaySchedule.count;
    }else if (_index == 1){
        return self.tomorrowSchedule.count;
    }else{
        return self.afterSchedule.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CinemaDtlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CinemaDtlTableViewCell"];
    Schedule *schedule;
    if (_index == 0) {
        schedule = self.todaySchedule[indexPath.row];
    }else if (_index == 1){
        schedule = self.tomorrowSchedule[indexPath.row];
    }else{
        schedule = self.afterSchedule[indexPath.row];
    }
    [cell configCellWithModel:schedule];
    cell.delegate = self;
    return cell;
}

@end
