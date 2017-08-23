//
//  ExchangeTicketViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/10.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ExchangeTicketViewCtl.h"
#import "SelectSeatView.h"
#import "ZFSeatsModel.h"
#import "ZFSeatModel.h"
#import "ZFSeatSelectionView.h"
#import "ZFSeatButton.h"
#import "RefundView.h"
#import "UIView+Extension.h"
#import "UIImage+DrawText.h"
@interface ExchangeTicketViewCtl ()<SelectSeatViewDelegate,RefundViewDelegate>
{
    SelectSeatView *_SelectSeat;
    MBProgressHUD *_loadSeatHUD;
    MBProgressHUD *_ExChangeHUD;
    UIButton *_confirmBtn;
    ZFSeatSelectionView *_seatsView;
    UIScrollView *_scrollView;
    NSArray *_recommend;
}
@property(nonatomic,strong) NSMutableDictionary *filmMessage;
@property(nonatomic,strong) NSMutableArray *seatsList;  //!<< 座位表
@property(nonatomic,strong) NSMutableArray *selectedSeats; //!<< 选中座位表

@end

@implementation ExchangeTicketViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.name;
    
    UIScrollView *scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -63) target:self];
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    
    [self loadExchangeTicket];
}

#pragma mark - Help Methods
- (void)loadExchangeTicket
{
    _loadSeatHUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_loadSeatHUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserExchangeTicketURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"id"] = self.id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            self.filmMessage = [NSMutableDictionary dictionaryWithDictionary:content[@"film"]];
            _recommend = content[@"recommend"];
            
            self.seatsList = [self fillSeatsListWithSeats:content[@"seat"]];
            [self setupUI];
            [_SelectSeat configMovieRoomWithDict:self.filmMessage];
            [_SelectSeat changeBestSeatViewWith:self.selectedSeats SeatsCount:1];
            
            [self initSelectionView:self.seatsList];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_loadSeatHUD hide:YES];
    } failure:^(NSError *error) {
        [_loadSeatHUD hide:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)setupUI
{
    _SelectSeat = [[SelectSeatView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 418)];
    _SelectSeat.delegate = self;
    _SelectSeat.twoSeatBtn.hidden = YES;
    _SelectSeat.threeSeatBtn.hidden = YES;
    _SelectSeat.fourSeatBtn.hidden = YES;
    _SelectSeat.exchangeBtn.hidden = YES;
    _SelectSeat.titleLb.text = @"推荐座位";
    [_SelectSeat.oneSeatBtn setTitle:@"1人" forState:UIControlStateNormal];
    [_scrollView addSubview:_SelectSeat];
    
    UIButton *commitBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(18, 418 +20, ScreenWidth -36, 45) title:@"确定" titleColor:[UIColor whiteColor] cornerRadius:3.0 font:[UIFont systemFontOfSize:18] backgroundColor:Color(252, 186, 0, 1.0) target:self action:@selector(conmitBtnDidClicked:) tag:100];
    _confirmBtn = commitBtn;
    _confirmBtn.backgroundColor = Color(204, 204, 204, 1.0);
    _confirmBtn.enabled = YES;
    [_scrollView addSubview:commitBtn];
}

//创建选座模块
-(void)initSelectionView:(NSMutableArray *)seatsModelArray{
    
    ZFSeatSelectionView *selectionView = [[ZFSeatSelectionView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 232) SeatsArray:seatsModelArray HallName:[NSString stringWithFormat:@"%@屏幕",self.filmMessage[@"hall_name"]] seatBtnActionBlock:^(NSMutableArray *seatsBtnsArray) {
        if (seatsBtnsArray.count != 1 && seatsBtnsArray.count != 0) {
            ZFSeatButton *btn = seatsBtnsArray[0];
            btn.selected = NO;
            [seatsBtnsArray removeObjectAtIndex:0];
            _seatsView.seatView.selectCount = 1;
        }
        [_seatsView.indicator updateMiniImageView];
        self.selectedSeats = [NSMutableArray arrayWithArray:seatsBtnsArray];
        NSLog(@"%zd个选中按钮",seatsBtnsArray.count);
        for (ZFSeatButton *btn in seatsBtnsArray) {
            //ZFSeatsModel *seatsModel = btn.seatsmodel;
            
            ZFSeatModel *seatModel = btn.seatmodel;
            NSInteger row = [seatModel.rowValue integerValue];
            NSInteger col = [seatModel.columnValue integerValue];
            NSLog(@"%zd排%zd座",row,col);
        }
        if (seatsBtnsArray.count != 0) {
            _confirmBtn.backgroundColor = Color(252, 186, 0, 1.0);
            _confirmBtn.enabled = YES;
        }else{
            _confirmBtn.backgroundColor = Color(204, 204, 204, 1.0);
            _confirmBtn.enabled = YES;
        }
        [_SelectSeat changeBestSeatViewWith:self.selectedSeats SeatsCount:1];
    }];
    _seatsView = selectionView;
    [_SelectSeat.movieRoomView addSubview:selectionView];
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

- (void)cancelSeatWithIndex:(NSInteger)index
{
    if (self.selectedSeats.count != 0) {
        NSLog(@"%@",self.selectedSeats[index]);
        ZFSeatButton *seatButton = self.selectedSeats[index];
        seatButton.selected = NO;
        [self.selectedSeats removeObject:seatButton];
        [_seatsView.seatBtns removeObject:seatButton];
        _seatsView.seatView.selectCount --;
        [_SelectSeat changeBestSeatViewWith:self.selectedSeats SeatsCount:1];
        if (self.selectedSeats.count == 0) {
            _confirmBtn.backgroundColor = Color(204, 204, 204, 1.0);
            _confirmBtn.enabled = YES;
        }
        //更新indicator大小位置
        [_seatsView.indicator updateMiniIndicator];
        [_seatsView.indicator updateMiniImageView];
        if (!_seatsView.indicator.hidden || _seatsView.seatScrollView.isZoomBouncing)return;
        _seatsView.indicator.alpha = 1;
        _seatsView.indicator.hidden = NO;
    }
}

/**
 兑换成功弹窗
 
 @param message 弹窗信息
 */
- (void)showPopWindowWithMessage:(NSString *)message
{
    NSString *content = message;
    CGSize contentSize = [FanShuToolClass createString:content font:[UIFont systemFontOfSize:16] lineSpacing:7 maxSize:CGSizeMake(ScreenWidth -60 -80, ScreenHeight)];
    RefundView *refund = [[RefundView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth -60, 95 +contentSize.height) WithContent:content];
    refund.headerView.hidden = YES;
    refund.contentView.frame = CGRectMake(23, 20 +17 +5, ScreenWidth -60 -80, contentSize.height);
    refund.contentView.center = CGPointMake(refund.frame.size.width / 2, (95 +contentSize.height -47) / 2);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.firstLineHeadIndent = 0;
    [paraStyle setLineSpacing:7];
    [str addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
    refund.contentView.attributedText = str;
    refund.delegate = self;
    
    [refund show];
}

#pragma mark - 懒加载
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
    if (event == SelectOneSeatEvent){
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
    }
}

// 推荐座位
- (BOOL)recommendSeatWithSeatArr:(NSArray *)recommendSeats
{
    BOOL notFind = NO;
    [self.selectedSeats removeAllObjects];
    for (NSDictionary *seat in recommendSeats) {
        
        ZFSeatButton *btn = (ZFSeatButton *)[_seatsView.seatView viewWithTag:[seat[@"cineSeatId"] integerValue]];
        NSLog(@"%@",seat[@"cineSeatId"]);
        if (btn == nil) {
            notFind = YES;
            break;
        }else{
            [self.selectedSeats addObject:btn];
            [_seatsView.seatBtns addObject:btn];
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
                CGRect zoomRect = [_seatsView _zoomRectInView:_seatsView.seatScrollView forScale:maximumZoomScale withCenter:CGPointMake(btn.centerX, btn.centerY)];
                [_seatsView.seatScrollView zoomToRect:zoomRect animated:YES];
            }
        }
    }
    if (!notFind) {
        _confirmBtn.backgroundColor = Color(252, 186, 0, 1.0);
        _confirmBtn.enabled = YES;
        [_SelectSeat changeBestSeatViewWith:self.selectedSeats SeatsCount:1];
        _seatsView.seatView.selectCount = self.selectedSeats.count;
    }
    return notFind;
}

#pragma mark - RefundViewDelegate
- (void)gotoRefundViewEvents:(NSInteger)tag
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - View Handle
- (void)conmitBtnDidClicked:(UIButton *)btn
{
    if (self.selectedSeats.count != 0) {
        _ExChangeHUD = [FanShuToolClass createMBProgressHUDWithText:@"兑换中..." target:self];
        [self.view addSubview:_ExChangeHUD];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserSuccessTicketURL];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        parameters[@"film_id"] = self.filmMessage[@"id"];
        parameters[@"seat_id"] = [[self.selectedSeats[0] seatmodel] cineSeatId];
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            if ([dataBack[@"code"] integerValue]== 0) {
                NSDictionary *content = dataBack[@"content"];
                NSString *message = @"电影票兑换成功，相应积分将自动扣除，电影票请在“我的订单”里面查看";
                [self showPopWindowWithMessage:message];
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
            [_ExChangeHUD hide:YES];
        } failure:^(NSError *error) {
            
            [self showHudMessage:@"连接服务器失败!"];
            [_ExChangeHUD hide:YES];
        }];
    }else{
        [self showHudMessage:@"请先选座"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
