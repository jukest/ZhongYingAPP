//
//  SelectSeatViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/2.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "SelectSeatViewCtl.h"
#import "PackageTableViewCell.h"
#import "SelectSeatView.h"
#import "MovieTimesView.h"
#import "ConfirmTicketOrderViewCtl.h"
#import "ZFSeatsModel.h"
#import "ZFSeatModel.h"
#import "ZFSeatSelectionView.h"
#import "ZFSeatButton.h"
#import "LoginViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIView+Extension.h"
#import "UIImage+DrawText.h"

@interface SelectSeatViewCtl ()<UITableViewDelegate,UITableViewDataSource,PackageTableViewCellDelegate,SelectSeatViewDelegate,MovieTimesViewDelegate>
{
    SelectSeatView *_headerView;
    MBProgressHUD *_HUD;
    UIButton *_confirmBtn;
    ZFSeatSelectionView *_seatsView;
    NSArray *_recommend; // 推荐座位
    
}

@property(nonatomic,strong) NSMutableDictionary *filmMessage;
@property(nonatomic,strong) NSMutableArray *todaySchedule;  //!<< 今天时间表
@property(nonatomic,strong) NSMutableArray *afterSchedule;  //!<< 后天时间表
@property(nonatomic,strong) NSMutableArray *tomorrowSchedule;  //!<< 明天时间表
@property(nonatomic,strong) NSMutableArray *seatsList;  //!<< 座位表
@property(nonatomic,strong) NSMutableArray *selectedSeats; //!<< 选中座位表
@property(nonatomic,strong) NSMutableDictionary *dict;  //!<< 选中套餐

@end

@implementation SelectSeatViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.cinemaMsg.title;
    
    //
    [self registerLJWKeyboardHandler];

    _headerView = [[SelectSeatView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 418)];
    _headerView.delegate = self;
    _dict = [NSMutableDictionary dictionary];
    self.SelectSeatTableView.tableHeaderView = _headerView;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = self.hotFilm.name;
    dict[@"index"] = @(self.index);
    dict[@"start_time"] = @(self.schedule.start_time);
    dict[@"language"] = self.schedule.language;
    dict[@"tags"] = self.schedule.tags;
    [_headerView configMovieRoomWithDict:dict];
    
    UIView *footerView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 74) backgroundColor:[UIColor whiteColor]];
    UIButton *confirmBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(18, 16, ScreenWidth -36, 45) title:@"确定" titleColor:[UIColor whiteColor] target:self action:@selector(ConfirmOrderViewEvents:) tag:666];
    //Color(252, 186, 0, 1.0)
    confirmBtn.backgroundColor = Color(204, 204, 204, 1.0);
    
    confirmBtn.layer.cornerRadius = 5.0;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.enabled = YES;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [footerView addSubview:confirmBtn];
    _confirmBtn = confirmBtn;
    self.SelectSeatTableView.tableFooterView = footerView;
    
    [self loadSeatWithFilmID:self.schedule.id];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    // 取消当前网络请求
    [connect cancel];
}

#pragma mark - help Methods
- (void)loadSeatWithFilmID:(NSInteger)film_id
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserSelectSeatURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"film_id"] = @(film_id);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getSelectSeat >>>>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            [self.todaySchedule removeAllObjects];
            [self.tomorrowSchedule removeAllObjects];
            [self.afterSchedule removeAllObjects];
            [self.seatsList removeAllObjects];
            [self.selectedSeats removeAllObjects];
            
            _dict = [NSMutableDictionary dictionary];
            _confirmBtn.enabled = YES;
            _confirmBtn.backgroundColor = Color(204, 204, 204, 1.0);
            
            [_headerView.movieRoomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            self.filmMessage = [NSMutableDictionary dictionaryWithDictionary:content[@"film"]];
            for (NSDictionary *dict in content[@"other_film"]) {
                NSError *error;
                Schedule *schedule = [[Schedule alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"selectSeat_error = %@",error);
                }
                if (schedule.time_type == 1) {  // 今天
                    [self.todaySchedule addObject:schedule];
                }else if (schedule.time_type == 2){  // 明天
                    [self.tomorrowSchedule addObject:schedule];
                }else{  // 后天
                    [self.afterSchedule addObject:schedule];
                }
            }
            _recommend = content[@"recommend"];
            
            self.seatsList = [self fillSeatsListWithSeats:content[@"seat"]];
            
            self.filmMessage[@"index"] = @(self.index);
            [_headerView configMovieRoomWithDict:self.filmMessage];
            [_headerView changeBestSeatViewWith:self.selectedSeats SeatsCount:4];
            [self initSelectionView:self.seatsList];
            [self.SelectSeatTableView reloadData];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hide:NO];
    } failure:^(NSError *error) {
        [_HUD hide:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

//创建选座模块
-(void)initSelectionView:(NSMutableArray *)seatsModelArray{
    
    ZFSeatSelectionView *selectionView = [[ZFSeatSelectionView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 232) SeatsArray:seatsModelArray HallName:[NSString stringWithFormat:@"%@屏幕",self.filmMessage[@"hall_name"]] seatBtnActionBlock:^(NSMutableArray *seatsBtnsArray) {
        NSLog(@"%zd个选中按钮",seatsBtnsArray.count);
        self.selectedSeats = [NSMutableArray arrayWithArray:seatsBtnsArray];
        for (ZFSeatButton *btn in seatsBtnsArray) {
            //ZFSeatsModel *seatsModel = btn.seatsmodel;
            
            ZFSeatModel *seatModel = btn.seatmodel;
            NSInteger row = [seatModel.rowValue integerValue];
            NSInteger col = [seatModel.columnValue integerValue];
            NSLog(@"%@ %zd排%zd座  x:%@  y:%@",seatModel.cineSeatId,row,col,seatModel.x,seatModel.y);
        }
        
        if (seatsBtnsArray.count != 0) {
            _confirmBtn.backgroundColor = Color(252, 186, 0, 1.0);
            _confirmBtn.enabled = YES;
        }else{
            _confirmBtn.backgroundColor = Color(204, 204, 204, 1.0);
            _confirmBtn.enabled = YES;
        }
        [_headerView changeBestSeatViewWith:self.selectedSeats SeatsCount:4];
    }];
    _seatsView = selectionView;
    [_headerView.movieRoomView addSubview:selectionView];
}


- (NSMutableArray *)fillSeatsListWithSeats:(NSArray *)seats
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSArray *rowSeat in seats) {
        ZFSeatsModel *seatsModel = [[ZFSeatsModel alloc] init];
        NSMutableArray *seatsModelArray = [NSMutableArray array];
        for (NSDictionary *seat in rowSeat) {
            NSError *error;
            ZFSeatModel *seatModel = [[ZFSeatModel alloc] initWithDictionary:seat error:&error];
            if (error) {
                NSLog(@"seat_Model_Error=%@",error);
            }
            [seatsModelArray addObject:seatModel];
        }
        seatsModel.columns = seatsModelArray;
        seatsModel.rowId = [(ZFSeatModel *)seatsModelArray[0] x];
        seatsModel.rowNum = [(ZFSeatModel *)seatsModelArray[0] x];
        [arr addObject:seatsModel];
    }
    
    
    
    return arr;
}

// 检测作为是否相邻
- (BOOL)checkNextOfSeats:(NSArray *)arr
{
    if (arr.count == 1) {
        return YES;
    }else{
        BOOL isNext = NO;
        NSMutableArray *checkArr = [NSMutableArray arrayWithArray:arr];
        for (NSInteger i = 0; i < arr.count; i ++) {
            if (checkArr.count == 0) {
                isNext = YES;
                break;
            }
            ZFSeatButton *checkBtn = checkArr[0];
            ZFSeatButton *seatBtn = arr[i];
            NSInteger checkRow = [checkBtn.seatmodel.rowValue integerValue];
            NSInteger checkCol = [checkBtn.seatmodel.columnValue integerValue];
            NSInteger checkX = [checkBtn.seatmodel.x integerValue];
            NSInteger checkY = [checkBtn.seatmodel.y integerValue];
            
            NSInteger seatRow = [seatBtn.seatmodel.rowValue integerValue];
            NSInteger seatCol = [seatBtn.seatmodel.columnValue integerValue];
            NSInteger seatX = [seatBtn.seatmodel.x integerValue];
            NSInteger seatY = [seatBtn.seatmodel.y integerValue];
            if ((checkX == seatX && (checkY == seatY +1 || checkY == seatY -1 || checkCol == seatCol +1 || checkCol == seatCol -1)) || (checkY == seatY && (checkX == seatX +1 || checkX == seatX -1 || checkRow == seatRow +1 || checkRow == seatRow -1))) {
                [checkArr removeObject:checkBtn];
                [checkArr removeObject:seatBtn];
                i = -1;
            }
        }
        return isNext;
    }
}

#pragma mark - View Handle
- (void)ConfirmOrderViewEvents:(UIButton *)btn
{
    NSLog(@"确定");
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
    }else{
        if (self.selectedSeats.count != 0) {
            if (![self checkNextOfSeats:self.selectedSeats]) {
                [self showHudMessage:@"请选择相邻的座位"];
                return;
            }
            NSMutableArray *seatIDs = [NSMutableArray array];
            for (ZFSeatButton *button in self.selectedSeats) {
                [seatIDs addObject:button.seatmodel.cineSeatId];
            }
            
            NSString *seat_id = [seatIDs componentsJoinedByString:@","];
            NSArray *keyArr = [self.dict allKeys];
            NSMutableArray *goods = [NSMutableArray array];
            for (NSString *key in keyArr) {
                if ([self.dict[key] integerValue] != 0) {
                    NSMutableDictionary *goods_dict = [NSMutableDictionary dictionary];
                    goods_dict[@"id"] = @([key integerValue]);
                    goods_dict[@"number"] = self.dict[key];
                    [goods addObject:goods_dict];
                }
            }
            ConfirmTicketOrderViewCtl *confirmOrder = [[ConfirmTicketOrderViewCtl alloc] init];
            confirmOrder.film_id = self.schedule.id;
            confirmOrder.seat_id = seat_id;
            confirmOrder.selectedSeats = self.selectedSeats;
            confirmOrder.cinema_name = self.cinemaMsg.title;
            if (goods.count != 0) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:goods options:NSJSONWritingPrettyPrinted error:nil];
                NSString *goods_info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"seat_id=%@ ,goods_info = %@",seat_id,goods_info);
                confirmOrder.hasSnack = YES;
                confirmOrder.goods_info = goods_info;
            }else{
                NSLog(@"seat_id=%@",seat_id);
                confirmOrder.hasSnack = NO;
            }
            [confirmOrder setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }else{
            [self showHudMessage:@"请先选座"];
        }
    }
}

#pragma mark - 懒加载
- (UITableView *)SelectSeatTableView
{
    if (_SelectSeatTableView == nil) {
        _SelectSeatTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped target:self];
        [_SelectSeatTableView registerClass:[PackageTableViewCell class] forCellReuseIdentifier:@"PackageTableViewCell"];
        [self.view addSubview:_SelectSeatTableView];
    }
    return _SelectSeatTableView;
}

- (NSMutableArray *)todaySchedule
{
    if (_todaySchedule == nil) {
        _todaySchedule = [NSMutableArray array];
    }
    return _todaySchedule;
}

- (NSMutableArray *)tomorrowSchedule
{
    if (_tomorrowSchedule == nil) {
        _tomorrowSchedule = [NSMutableArray array];
    }
    return _tomorrowSchedule;
}

- (NSMutableArray *)afterSchedule
{
    if (_afterSchedule == nil) {
        _afterSchedule = [NSMutableArray array];
    }
    return _afterSchedule;
}

- (NSMutableArray *)seatsList
{
    if (_seatsList == nil) {
        _seatsList = [NSMutableArray array];
    }
    return _seatsList;
}

- (NSMutableArray *)selectedSeats
{
    if (_selectedSeats == nil) {
        _selectedSeats = [NSMutableArray array];
    }
    return _selectedSeats;
}

#pragma mark - SelectSeatViewDelegate
- (void)gotoSelectSeatViewEvent:(SelectSeatViewEvents)event
{
    if (event == ExchangeMovieEvent) {
        NSLog(@"换一场");
        CGFloat height;
        if (self.todaySchedule.count >= 3) {
            height = 241;
        }else{
            if (self.todaySchedule.count != 0) {
                height = 40 +67 * self.todaySchedule.count;
            }else{
                if (self.tomorrowSchedule.count >= 3) {
                    height = 241;
                }else{
                    if (self.tomorrowSchedule.count != 0) {
                        height = 40 +67 * self.tomorrowSchedule.count;
                    }else{
                        if (self.afterSchedule.count >= 3) {
                            height = 241;
                        }else{
                            height = 40 +67 * self.afterSchedule.count;
                        }
                    }
                }
            }
        }
        MovieTimesView *movieTimes = [[MovieTimesView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth -58, height)
                                                              WithTodayArr:self.todaySchedule
                                                               tomorrowArr:self.tomorrowSchedule
                                                                     after:self.afterSchedule];
        movieTimes.delegate = self;
        movieTimes.layer.cornerRadius = 3.0f;
        movieTimes.layer.masksToBounds = YES;
        [movieTimes show];
    }else if (event == SelectOneSeatEvent){
        if (self.selectedSeats.count == 0) {
            if (![_recommend isEqual:[NSNull null]]&&_recommend.count != 0) {
                NSLog(@"1座");
                if ([self recommendSeatWithSeatArr:_recommend[0]]) {
                    [self showHudMessage:@"没有1座推荐"];
                }
            }else{
                [self showHudMessage:@"没有1座推荐"];
            }
        }else{
            [self cancelSeatWithIndex:event -667];
        }
    }else if (event == SelectTwoSeatEvent){
        if (self.selectedSeats.count == 0) {
            if (![_recommend isEqual:[NSNull null]]&&_recommend.count >= 2) {
                NSLog(@"2座");
                if ([self recommendSeatWithSeatArr:_recommend[1]]) {
                    
                    [self showHudMessage:@"没有2座推荐"];
                }
            }else{
                [self showHudMessage:@"没有2座推荐"];
            }
        }else{
            [self cancelSeatWithIndex:event -667];
        }
    }else if (event == SelectThreeSeatEvent){
        if (self.selectedSeats.count == 0) {
            if (![_recommend isEqual:[NSNull null]]&&_recommend.count >= 3) {
                NSLog(@"3座");
                if ([self recommendSeatWithSeatArr:_recommend[2]]) {
                    [self showHudMessage:@"没有3座推荐"];
                }
            }else{
                [self showHudMessage:@"没有3座推荐"];
            }
        }else{
            [self cancelSeatWithIndex:event -667];
        }
    }else if (event == SelectFourSeatEvent){
        if (self.selectedSeats.count == 0) {
            if (![_recommend isEqual:[NSNull null]]&&_recommend.count >= 4) {
                NSLog(@"4座");
                if ([self recommendSeatWithSeatArr:_recommend[3]]) {
                    [self showHudMessage:@"没有4座推荐"];
                }
            }else{
                [self showHudMessage:@"没有4座推荐"];
            }
        }else{
            [self cancelSeatWithIndex:event -667];
        }
    }
}

// 推荐座位
- (BOOL)recommendSeatWithSeatArr:(NSArray *)recommendSeats
{
    BOOL notFind = NO; // 查找推进座位结果
    [self.selectedSeats removeAllObjects];
    for (NSDictionary *seat in recommendSeats) {
        // 根据tag获取座位按钮
        ZFSeatButton *btn = (ZFSeatButton *)[_seatsView.seatView viewWithTag:[seat[@"cineSeatId"] integerValue]];
        // NSLog(@"%@",seat[@"cineSeatId"]);
        if (btn == nil) {// 如果有找不到的座位，就不推荐
            notFind = YES;
            [self.selectedSeats removeAllObjects];
            [_seatsView.seatBtns removeAllObjects];
            break;
        }else{  //如果最佳推荐都找到了，就推荐
            [self.selectedSeats addObject:btn];
            [_seatsView.seatBtns addObject:btn];
            // btn.selected = YES;
        }
    }
    if (!notFind) {
        _confirmBtn.backgroundColor = Color(252, 186, 0, 1.0);
        _confirmBtn.enabled = YES;
        [_headerView changeBestSeatViewWith:self.selectedSeats SeatsCount:4];
        _seatsView.seatView.selectCount = self.selectedSeats.count;
        for (ZFSeatButton *btn in self.selectedSeats) {
            btn.selected = YES;
            
            // 选中时候设置绘制文字的背景图片
            UIImage *image = [UIImage imageNamed:@"selected"];
            NSInteger row = [btn.seatmodel.rowValue integerValue];
            NSInteger col = [btn.seatmodel.columnValue integerValue];
            image = [image imageWithTitle:[NSString stringWithFormat:@"%zd排\n%zd座",row,col] fontSize:5.5];
            [btn setImage:image forState:UIControlStateSelected];
            
            if (_seatsView.seatScrollView.maximumZoomScale - _seatsView.seatScrollView.zoomScale >= 0.1)//设置座位放大
            {
                CGFloat maximumZoomScale = _seatsView.seatScrollView.maximumZoomScale;
                CGRect zoomRect = [_seatsView _zoomRectInView:_seatsView.seatScrollView
                                                     forScale:maximumZoomScale
                                                   withCenter:CGPointMake(btn.centerX, btn.centerY)];
                [_seatsView.seatScrollView zoomToRect:zoomRect animated:YES];
            }
        }
        [self updateMiniImageView];
    }
    return notFind;
}

// 取消选中座位
- (void)cancelSeatWithIndex:(NSInteger)index
{
    if (self.selectedSeats.count != 0) {
        ZFSeatButton *seatButton = self.selectedSeats[index];
        seatButton.selected = NO;
        [self.selectedSeats removeObject:seatButton];
        [_seatsView.seatBtns removeObject:seatButton];
        _seatsView.seatView.selectCount --;
        [_headerView changeBestSeatViewWith:self.selectedSeats SeatsCount:4];
        if (self.selectedSeats.count == 0) {
            _confirmBtn.backgroundColor = Color(204, 204, 204, 1.0);
            _confirmBtn.enabled = NO;
        }
        [self updateMiniImageView];
    }
}

- (void)updateMiniImageView
{
    //更新indicator大小位置
    [_seatsView.indicator updateMiniIndicator];
    [_seatsView.indicator updateMiniImageView];
    if (!(!_seatsView.indicator.hidden || _seatsView.seatScrollView.isZoomBouncing)){
        _seatsView.indicator.alpha = 1;
        _seatsView.indicator.hidden = NO;
    }
}

#pragma mark - MovieTimesViewDelegate
/**
 选择场次回调
 
 @param indexPath 场次indexPath
 @param index     场次日期
 */
- (void)gotoMovieTimesViewEventIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index
{
    Schedule *schedule;
    if (index == 0) {  //今天
        schedule = self.todaySchedule[indexPath.row];
    }else if (index == 1){  //明天
        schedule = self.tomorrowSchedule[indexPath.row];
    }else{  //后天
        schedule = self.afterSchedule[indexPath.row];
    }
    self.index = index;
    self.schedule = schedule;
    [self loadSeatWithFilmID:schedule.id];
}

#pragma mark - PackageTableViewCellDelegate
- (void)gotoPackageAmountChangeEvent:(NSInteger)amount indexPath:(NSIndexPath *)index
{
    Goods *goods = self.goodsList[index.row];
    self.dict[[NSString stringWithFormat:@"%zd",goods.id]] = @(amount);
}

- (void)gotoPackageAmountUpperLimitEvent
{
    [self showHudMessage:@"该套餐最多能选择9份"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.goodsList.count != 0) {
        return 47;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.goodsList.count != 0) {
        UIView *headerView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 47)
                                                  backgroundColor:Color(245, 245, 245, 1.0)];
        UILabel *lb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 20, 200, 20)
                                                       text:@"观影套餐"
                                                       font:[UIFont systemFontOfSize:15]
                                                  textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        [headerView addSubview:lb];
        return headerView;
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Goods *goods = self.goodsList[indexPath.row];
    PackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageTableViewCell"];
    [cell configCellWithModel:goods];
    if (self.dict[[NSString stringWithFormat:@"%zd",goods.id]] != nil) {
        cell.amountFld.text = [NSString stringWithFormat:@"%@",self.dict[[NSString stringWithFormat:@"%zd",goods.id]]];
    }else{
        cell.amountFld.text = @"0";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.index = indexPath;
    cell.selectBtn.hidden = YES;
    return cell;
}

@end
