//
//  CouponViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/1.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CouponViewCtl.h"
#import "CouponTableViewCell.h"
#import "CouponDescriptionViewCtl.h"
#import "Coupon.h"

@interface CouponViewCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *couponList;
@property(nonatomic,strong) NSMutableArray *selectedCoupon;

@end

@implementation CouponViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color(239, 239, 239, 1.0);
    self.navigationItem.title = @"优惠券";
    UIButton *rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 24, 24) image:[UIImage imageNamed:@"coupon_right"] target:self action:@selector(gotoCouponEvents:) tag:10001];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self loadCouponList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                // 筛选优惠券
                if ((self.hasTicket && [coupon.type integerValue] == 1) || (self.hasSnack && [coupon.type integerValue] == 2)) {
                    [self.couponList addObject:coupon];
                }
                
                for (NSString *coupon_id in self.coupon_ids) {
                    if ([coupon.id isEqualToString:coupon_id]) {
                        [self.selectedCoupon addObject:coupon];
                        break;
                    }
                }
            }
            if (self.couponList.count != 0) {
                [self setupCouponUI];
            }else{
                [self showHudMessage:@"您还没有优惠券!"];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            [self showHudMessage:@"您还没有优惠券!"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)setupCouponUI
{
    self.couponTableView.tableHeaderView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 15) backgroundColor:[UIColor clearColor]];
    
    UIView *footer = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 100) backgroundColor:[UIColor clearColor]];
    UIButton *confirmBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12, 30, ScreenWidth -24, 55) title:@"确认" titleColor:[UIColor whiteColor] target:self action:@selector(gotoCouponEvents:) tag:10002];
    confirmBtn.layer.cornerRadius = 5.0;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    confirmBtn.backgroundColor = Color(252, 186, 0, 1.0);
    [footer addSubview:confirmBtn];
    self.couponTableView.tableFooterView = footer;
}

#pragma mark - Help Methods
- (void)gotoCouponEvents:(UIButton *)btn
{
    if (btn.tag == 10001) {
        NSLog(@"优惠券说明");
        CouponDescriptionViewCtl *couponDescription = [[CouponDescriptionViewCtl alloc] init];
        [couponDescription setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:couponDescription animated:YES];
        
    }else if (btn.tag == 10002){
        self.block(self.selectedCoupon);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 懒加载
- (UITableView *)couponTableView
{
    if (_couponTableView == nil) {
        _couponTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStylePlain target:self];
        [_couponTableView registerClass:[CouponTableViewCell class] forCellReuseIdentifier:@"CouponTableViewCell"];
        _couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _couponTableView.backgroundColor = Color(239, 239, 239, 1.0);
        [self.view addSubview:_couponTableView];
    }
    return _couponTableView;
}

- (NSMutableArray *)couponList
{
    if (_couponList == nil) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}

- (NSMutableArray *)selectedCoupon
{
    if (_selectedCoupon == nil) {
        _selectedCoupon = [NSMutableArray array];
    }
    return _selectedCoupon;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coupon *coupon = self.couponList[indexPath.row];
    CouponTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![self.selectedCoupon containsObject:coupon]) {
        
        if (!self.hasSnack && [coupon.type integerValue] == 2) {
            [self showHudMessage:@"购买本店观影套餐可用"];
        }else if(!self.hasTicket && [coupon.type integerValue] == 1){
            [self showHudMessage:@"购买本店电影票可用"];
        }else{
            for (Coupon *selectCou in self.selectedCoupon) {
                if ([selectCou.type isEqualToString:coupon.type]) {
                    [self.selectedCoupon removeObject:selectCou];
                    break;
                }
            }
            [self.selectedCoupon addObject:coupon];
            cell.selectBtn.selected = YES;
        }
    }else{
        cell.selected = NO;
        [self.selectedCoupon removeObject:coupon];
    }
    [self.couponTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coupon *coupon = self.couponList[indexPath.row];
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell"];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:coupon];
    if ([self.selectedCoupon containsObject:coupon]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}

@end
