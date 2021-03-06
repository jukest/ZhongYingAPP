//
//  MyOrderViewCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/17.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyOrderViewCtl.h"
#import "YSLContainerViewController.h"
#import "NoTicketTableViewCtl.h"
#import "HistoryTableViewCtl.h"
#import "UIViewController+BackButtonHandler.h"

@interface MyOrderViewCtl ()<YSLContainerViewControllerDelegate>

@end

@implementation MyOrderViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的订单";
    [self initMyOrderViewUI];
    [self setBackItem];
}

- (void)setBackItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"movie_back"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.frame = CGRectMake(0, 0, 50, 30);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [button addTarget:self action:@selector(backItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item= [[UIBarButtonItem alloc]initWithCustomView:button];;
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backItemAction {
    
    if (self.isFromPayMent) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFromPayMent"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initMyOrderViewUI{
    NoTicketTableViewCtl *noTicket = [[NoTicketTableViewCtl alloc] init];
    noTicket.title = @"未取票订单";
    
    HistoryTableViewCtl *history = [[HistoryTableViewCtl alloc] init];
    history.title = @"历史订单";
    
    [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"kYSLScrollMenuCount"];
    YSLContainerViewController *YSLContainer = [[YSLContainerViewController alloc] initWithControllers:@[noTicket,history] topBarHeight:HEIGHT_STATUSBAR+HEIGHT_NAVBAR parentViewController:self];
    YSLContainer.delegate = self;
    YSLContainer.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16 * widthFloat];
    [self.view addSubview:YSLContainer.view];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (self.isFromPayMent && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (self.isFromPayMent && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (BOOL)navigationShouldPopOnBackButton
{
    if (self.isFromPayMent) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFromPayMent"];
    }
    return YES;
}

@end
