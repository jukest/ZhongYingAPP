//
//  MyCouponViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyCouponViewCtl.h"
#import "CouponDescriptionViewCtl.h"
#import "MyCouponCell.h"
#import "Coupon.h"
@interface MyCouponViewCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *couponList;

@end

@implementation MyCouponViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color(239, 239, 239, 1.0);
    self.navigationItem.title = @"优惠券";
    UIButton *rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 24, 24) image:[UIImage imageNamed:@"coupon_right"] target:self action:@selector(gotoCouponEvents:) tag:10001];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.couponTableView.tableHeaderView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 15) backgroundColor:[UIColor clearColor]];
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
                [self.couponList addObject:coupon];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            [self showHudMessage:@"你还没有优惠券信息!"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self.couponTableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

#pragma mark - view handle
- (void)gotoCouponEvents:(UIButton *)btn
{
    if (btn.tag == 10001) {
        NSLog(@"优惠券说明");
        CouponDescriptionViewCtl *couponDescription = [[CouponDescriptionViewCtl alloc] init];
        [couponDescription setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:couponDescription animated:YES];
    }
}

#pragma mark - 懒加载
- (UITableView *)couponTableView
{
    if (_couponTableView == nil) {
        _couponTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain target:self];
        [_couponTableView registerClass:[MyCouponCell class] forCellReuseIdentifier:@"MyCouponCell"];
        _couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _couponTableView.backgroundColor = Color(239, 239, 239, 1.0);
        [self.view addSubview:_couponTableView];
    }
    return _couponTableView;
}

- (NSMutableArray *)couponList
{
    if (_couponList == nil) {
        _couponList = [[NSMutableArray alloc] init];
    }
    return _couponList;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponCell"];
    Coupon *coupon = self.couponList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:coupon];
    return cell;
}

@end
