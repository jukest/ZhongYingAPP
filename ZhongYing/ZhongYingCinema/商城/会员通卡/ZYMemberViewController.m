//
//  ZYMemberViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMemberViewController.h"
#import "ZYZYMemberViewControllerTableViewHeaderView.h"
#import "RefundView.h"
#import "Coupon.h"
#import "MyCouponViewCtl.h"
#import "RechargeViewController.h"
#import "IntegralMallViewCtl.h"

#import "ZYIntegralMainViewController.h"


@interface ZYMemberViewController ()<UITableViewDelegate,UITableViewDataSource,ZYZYMemberViewControllerTableViewHeaderViewDelegate>
{
    MBProgressHUD *_HUD;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property(nonatomic,strong) NSMutableArray *couponList;

@property (nonatomic, strong) ZYZYMemberViewControllerTableViewHeaderView *header;
@end

@implementation ZYMemberViewController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"余额充值立即享受中影泰得影城APP会员优惠服务，优惠范围包括影票、卖品、电影周边产品",@"中影泰得影城APP会员专享电影票8折优惠",@"本卡仅限APP上使用",@"充值的余额只针对单店有效，在哪家影城充值，就只能在哪家店使用"];
    }
    return _titleArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];//mall_member
    [self.view addSubview:self.tableView];
    
    self.header = [[ZYZYMemberViewControllerTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 280)];
    self.header.delegate = self;
    
    self.tableView.tableHeaderView = self.header;
    
    self.header.balanceStr =  [NSString stringWithFormat:@"¥%.2f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"myremain"] floatValue]];//
    self.header.integralStr = [NSString stringWithFormat:@"%.2f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"myscore" ] floatValue]];
    NSString *content = @"会员功能还在开发中";
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:shareAction];
    
//    [self presentViewController:alertC animated:YES completion:nil];
    
    [self loadCouponList];
    

}

- (NSMutableArray *)couponList
{
    if (_couponList == nil) {
        _couponList = [[NSMutableArray alloc] init];
    }
    return _couponList;
}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14*heightFloat];
    cell.imageView.image = [UIImage imageNamed:@"dot"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = Color(240, 240, 240, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 28)];
    label.text = @"   会员详情";
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:label];
    
   
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 38, ScreenWidth, 2)];
    line1.backgroundColor = [UIColor whiteColor];//Color(240, 240, 240, 1);
    [view addSubview:line1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 38, ScreenWidth - 10, 2)];
    line.backgroundColor = Color(240, 240, 240, 1);
    [view addSubview:line];
    
    return view;
}


#pragma mark -- ZYZYMemberViewControllerTableViewHeaderViewDelegate 

- (void)tableViewHeaderView:(ZYZYMemberViewControllerTableViewHeaderView *)headerView didClickButton:(UIButton *)button type:(MyMemberCardButtonType)buttonType {
    if (buttonType == MyCouponButtonType) {
        MyCouponViewCtl *coupon = [[MyCouponViewCtl alloc] init];
        coupon.title = @"优惠券";
        [coupon setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:coupon animated:YES];
    } else if (buttonType == MyBalanceButtonType ) {//余额
        // 前往充值
        RechargeViewController *rechargeCtl = [[RechargeViewController alloc] init];
        [rechargeCtl setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:rechargeCtl animated:YES];
    } else if (buttonType == MyIntegralButtonType) {//积分商城
        
//        IntegralMallViewCtl *integralMall = [[IntegralMallViewCtl alloc] init];
        ZYIntegralMainViewController *integralMall = [[ZYIntegralMainViewController alloc] initWithIsMain:NO];
        integralMall.title = @"积分商城";
        [integralMall setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:integralMall animated:YES];
    }
}

#pragma mark - help methods
- (void)loadCouponList
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserCouponListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getCouponList >>>>>>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Coupon *coupon = [[Coupon alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error === %@",error);
                }
                [self.couponList addObject:coupon];
            }
            self.header.couponStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.couponList.count];
        }else if([dataBack[@"code"] integerValue] == 46005){
//            [self showHudMessage:@"你还没有优惠券信息!"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
    }];
}


@end














