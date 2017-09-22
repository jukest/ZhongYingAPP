//
//  IntegralMallViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/9.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "IntegralMallViewCtl.h"
#import "IntegralDescriptionViewCtl.h"
#import "MyIntegralTableViewCtl.h"
#import "ExchangeRecordTableViewCtl.h"
#import "YSLContainerViewController.h"

#import "informationSliderView.h"


@interface IntegralMallViewCtl ()<YSLContainerViewControllerDelegate,infoSliderViewDelegate>

@end

@implementation IntegralMallViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"积分商城";
    UIButton *rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 24, 24) image:[UIImage imageNamed:@"coupon_right"] target:self action:@selector(gotoMallEvents:) tag:100];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self initIntegralMallUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoMallEvents:(UIButton *)btn
{
    IntegralDescriptionViewCtl *integralDescription = [[IntegralDescriptionViewCtl alloc] init];
    [integralDescription setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:integralDescription animated:YES];
}

- (void)initIntegralMallUI{
    
    
    MyIntegralTableViewCtl *myIntegral = [[MyIntegralTableViewCtl alloc] init];
    myIntegral.title = [NSString stringWithFormat:@"我的积分：%@分",ApiMyScoreStr];
    
    ExchangeRecordTableViewCtl *exchangeRecord = [[ExchangeRecordTableViewCtl alloc] init];
    exchangeRecord.title = @"兑换记录";
    
    [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"kYSLScrollMenuCount"];
   
    YSLContainerViewController *YSLContainer = [[YSLContainerViewController alloc] initWithControllers:@[myIntegral,exchangeRecord] topBarHeight:64 parentViewController:self];
    YSLContainer.delegate = self;
    YSLContainer.menuItemFont = [UIFont systemFontOfSize:16 * widthFloat];
    [self.view addSubview:YSLContainer.view];
}

#pragma mark - YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

@end
