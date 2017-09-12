//
//  ZYFoodViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYFoodViewController.h"
#import "WXMoveBtn.h"
#import "Goods.h"
#import "ZYMallCell.h"
#import "ZYMallConfirmViewController.h"

@interface ZYFoodViewController ()<UITableViewDelegate,UITableViewDataSource,ZYMallCellDelegate>


@property (nonatomic, strong)WXMoveBtn *buyBtn;//点我购买

/** tableView */
@property (nonatomic, strong) UITableView *tableView;



@property(nonatomic,strong) NSMutableArray *goodsList;

@property (nonatomic, assign) NSInteger totalNumber;


@end


static NSString *reuseIdentifier = @"mallCell";

@implementation ZYFoodViewController


#pragma mark - 懒加载

- (NSMutableArray *)goodsList
{
    if (_goodsList == nil) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[ZYMallCell class] forCellReuseIdentifier:reuseIdentifier];
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor  = Color(246, 246, 246, 1);
;
    [self setupUI];
    
    self.totalNumber = 0;
    
    //加载数据
//    [self loadData];
    
    
    
    //添加 选择影院之后 的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFood) name:SelectedCimemaUpdataOtherDataNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

#pragma mark -- setupUI
- (void)setupUI {
    [self setupMoveBtn];
    [self addRefreshView];
    
    [self.view bringSubviewToFront:self.buyBtn];

    
}


- (void)addRefreshView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadFood];
    }];
    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self loadData];
//    }];
    //[self hideRefreshViewsubViews:self.informationTableView];
}

- (void)endRefresh {
    //TODO:--下拉刷新时,数据清零
    if ([self.tableView.mj_header isRefreshing]) {//下拉刷新时,数据清零
        [self.tableView.mj_header endRefreshing];
        [self.goodsList removeAllObjects];
        self.totalNumber = 0;
    }
    
    
}

- (void)setupMoveBtn {
    __weak typeof(self) weakSelf = self;
    self.buyBtn = [[WXMoveBtn alloc]initWithFrame:CGRectMake(10, ScreenHeight - 64 - 49 - 80, 40, 40)];
    self.buyBtn.btnDidClickBlock = ^{
        if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
            [(ZYNavigationController *)weakSelf.navigationController showLoginViewController];
        }else{
            
            if ([weakSelf selectedGoodsNumber] == 0) {
                
                [weakSelf showHudMessage:@"请选择商品"];
                return ;
            }
            ZYMallConfirmViewController *confirmVC = [[ZYMallConfirmViewController alloc]init];
            confirmVC.goodsList = [[weakSelf selectedGoods] mutableCopy];
            confirmVC.hidesBottomBarWhenPushed = YES;
            confirmVC.callBack = ^{
                
                [weakSelf.tableView reloadData];
            };
            [weakSelf.navigationController pushViewController:confirmVC animated:YES];
        }
    };
    [self.view addSubview:self.buyBtn];

}

#pragma mark - UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMallCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    Goods *good = self.goodsList[indexPath.row];
    cell.delegate = self;
    cell.good = good;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZYMallViewControllerCellHeight;
}

#pragma mark - UITableViewDelegate 


#pragma mark -- ZYMallCellDelegate

- (void)mallCell:(UITableViewCell *)cell plusBtnDidClick:(UIButton *)button withNumberOfGood:(NSInteger)number {
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    Goods *good = self.goodsList[index];
//    NSLog(@"买%ld",(long)good.selectedNumber);

}

- (void)mallCell:(UITableViewCell *)cell subtractBtnDidClick:(UIButton *)button withNumberOfGood:(NSInteger)number {
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    Goods *good = self.goodsList[index];
//    NSLog(@"还剩:%ld",(long)good.selectedNumber);
    
    
}

#pragma mark -- 获取选中的商品
- (NSArray <Goods *>*)selectedGoods {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < self.goodsList.count; i++) {
        Goods *good = self.goodsList[i];
        if (good.selectedNumber != 0) {
            [array addObject:good];
        }
    }
    return [array copy];
}

#pragma mark -- 获取选中商品的总数
- (NSInteger)selectedGoodsNumber {
    NSInteger totalNumber = 0;
    
    for (int i = 0; i < self.goodsList.count; i++) {
        Goods *good = self.goodsList[i];
        totalNumber += good.selectedNumber;
    }
    
    
    return totalNumber;
}

#pragma mark - 加载数据

- (void)loadFood {
    __weak typeof (self) weakSelf = self;
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
        
        [weakSelf endRefresh];
        
        NSLog(@"getGoods>>>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            
            [weakSelf.goodsList removeAllObjects];
            
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"goods"]) {
                Goods *goods = [Goods mj_objectWithKeyValues:dict];
                
                [weakSelf.goodsList addObject:goods];

            }
            
            [self.tableView reloadData];
        }else{
            [weakSelf showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        
        [weakSelf endRefresh];

        [self showHudMessage:@"连接服务器失败!"];
    }];
}



@end
