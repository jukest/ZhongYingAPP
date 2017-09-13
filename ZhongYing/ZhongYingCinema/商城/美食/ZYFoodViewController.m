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
#import "PictureView.h"

@interface ZYFoodViewController ()<UITableViewDelegate,UITableViewDataSource,ZYMallCellDelegate>


//@property (nonatomic, strong)WXMoveBtn *buyBtn;//点我购买

/** tableView */
@property (nonatomic, strong) UITableView *tableView;



@property(nonatomic,strong) NSMutableArray *goodsList;

@property (nonatomic, assign) NSInteger totalNumber;


@property (nonatomic, strong) UIView *footerView;
/** 还需支付 */
@property (nonatomic, strong) UILabel *totalMoneyLabel;
/** payBtn */
@property (nonatomic, strong) UIButton *buyBtn;

@end


static NSString *reuseIdentifier = @"mallCell";

@implementation ZYFoodViewController


#pragma mark - 懒加载

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44 * 2 - 64, ScreenWidth, 44)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 2)];
        lineView.backgroundColor = Color(247, 247, 247, 1);
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:lineView];
    }
    return _footerView;
}

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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self setupFooterView];

    [self addRefreshView];
    
    [self.view bringSubviewToFront:self.footerView];

    
}


- (void)setupFooterView{
    [self.view addSubview:self.footerView];
    
    //totalmoney
    UILabel *label = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 0, ScreenWidth - 100 - 20, self.footerView.height) text:@"需支付 0.0元" font:[UIFont systemFontOfSize:15] textColor:[UIColor redColor] alignment:NSTextAlignmentLeft];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSRange strRange = [label.text rangeOfString:@"需支付"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
    label.attributedText = attributeStr;
    [self.footerView addSubview:label];
    self.totalMoneyLabel = label;
    
    self.buyBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(20+label.width, 0, 100, self.footerView.height) title:@"立即购买" titleColor:[UIColor whiteColor] target:self action:@selector(payBtnAction:) tag:100];
    self.buyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.buyBtn.backgroundColor = Color(252, 186, 0, 0.9);
    [self.footerView addSubview:self.buyBtn];
    
    
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



- (void)payBtnAction:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
            [(ZYNavigationController *)self.navigationController showLoginViewController];
        } else {
            
            if ([self selectedGoodsNumber] == 0) {
                
                [self showHudMessage:@"请选择商品"];
                return ;
            }
            ZYMallConfirmViewController *confirmVC = [[ZYMallConfirmViewController alloc]init];
            confirmVC.goodsList = [[self selectedGoods] mutableCopy];
            confirmVC.hidesBottomBarWhenPushed = YES;
            confirmVC.callBack = ^{
                
                [weakSelf.tableView reloadData];
                [weakSelf setTotalMoneyLabelText];
                
            };
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
  
//    [self.view addSubview:self.buyBtn];
    
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
   
    [self setTotalMoneyLabelText];
    


}

- (void)mallCell:(UITableViewCell *)cell subtractBtnDidClick:(UIButton *)button withNumberOfGood:(NSInteger)number {
    [self setTotalMoneyLabelText];
    
}

- (void)mallCell:(UITableViewCell *)cell imageViewDidClick:(UIImageView *)imageView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Goods *good = self.goodsList[indexPath.row];
    
    // 查看图片
        NSLog(@"%zd",index);
        PictureView *pictureView = [[PictureView alloc] initWithFrame:self.view.bounds WithUrlStr:good.images Sliders:@[good.images] Index:0];
        
        [pictureView show];
   
    
}

- (void)setTotalMoneyLabelText {
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"需支付 %.2f元",[self totalMoney]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.totalMoneyLabel.text];
    NSRange strRange = [self.totalMoneyLabel.text rangeOfString:@"需支付"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:Color(60, 60, 60, 1.0) range:strRange];
    self.totalMoneyLabel.attributedText = attributeStr;
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

#pragma mark -- 计算总价
- (CGFloat)totalMoney {
    CGFloat money = 0;
    
    for (int i = 0; i<self.goodsList.count; i++) {
        Goods *good = self.goodsList[i];
        money += good.selectedNumber * good.price;
    }
    
    return money;
    
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
            
            [weakSelf.tableView reloadData];
            [weakSelf setTotalMoneyLabelText];
        }else{
            [weakSelf showHudMessage:dataBack[@"message"]];
        }
    } failure:^(NSError *error) {
        
        [weakSelf endRefresh];

        [self showHudMessage:@"连接服务器失败!"];
    }];
}



@end
