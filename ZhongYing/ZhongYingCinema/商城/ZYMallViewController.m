//
//  ZYMallViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMallViewController.h"
#import "WXSegementControl.h"
//#import "IntegralMallViewCtl.h"

#import "ZYFoodViewController.h"
#import "ZYIntegralMainViewController.h"

@interface ZYMallViewController ()<WXSegementControlDelegate,UIScrollViewDelegate>

/**
 首页分页控件
 */
@property (nonatomic, strong) WXSegementControl *segemetnControl;
@property (nonatomic, strong) NSArray <NSString *> *segementControlTitles;

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray <NSString *>*viewControllerNames;

@property (nonatomic, assign) NSInteger didSegementIndex;
@property (nonatomic, assign) BOOL receiveLogOutNotification;
@end

@implementation ZYMallViewController


#pragma mark - 懒加载
- (WXSegementControl *)segemetnControl {
    
    if (!_segemetnControl) {
        _segemetnControl = [[WXSegementControl alloc]initWithFrame:CGRectMake(0, 0, 150, 30) withItems:self.segementControlTitles];
        _segemetnControl.delegate = self;
    }
    return _segemetnControl;
}

- (NSArray<NSString *> *)segementControlTitles {
    if (!_segementControlTitles) {
        _segementControlTitles = @[@"卖品",@"积分"];
    }
    return _segementControlTitles;
}

- (NSMutableArray<NSString *> *)viewControllerNames {
    if (!_viewControllerNames) {
//        _viewControllerNames = @[@"ZYFoodViewController",@"ZYMemberViewController"].mutableCopy;
        _viewControllerNames = @[@"ZYFoodViewController",@"ZYIntegralMainViewController"].mutableCopy;

    }
    return _viewControllerNames;
}


#pragma mark -- 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -49)];
        _scrollView.contentSize = CGSizeMake(self.segementControlTitles.count * ScreenWidth, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;

        _scrollView.bounces = NO;
    }
    return  _scrollView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segemetnControl;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    self.didSegementIndex = 0;
    self.receiveLogOutNotification = NO;
    
    __weak typeof(self) weakSelf = self;
    self.segemetnControl.callBackBlock = ^(NSInteger index) {
        
        if ( ![LoginYesOrNoStr isEqualToString:@"YES"]) {
            if (weakSelf.didSegementIndex != index) {
                
                [(ZYNavigationController *)weakSelf.navigationController showLoginViewController];
            }
        }else {
            CGPoint point = CGPointMake(index * ScreenWidth, 0);
            [weakSelf.scrollView setContentOffset:point animated:YES];
        }
        weakSelf.didSegementIndex = index;
    };

    [self addChildViewControlers];
    
    //添加退出登录的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutNotificaiton) name:LogOutNotification object:nil];
}

#pragma mark -- 通知
- (void)logOutNotificaiton {
    self.receiveLogOutNotification = YES;
     //退出登录
    self.didSegementIndex = 0;
    CGPoint point = CGPointMake(0 * ScreenWidth, 0);
    [self.scrollView setContentOffset:point animated:YES];
    [self.segemetnControl btnAction:self.segemetnControl.buttons[0]];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFromPayMent"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 3;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFromPayMent"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFromApn"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 0;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFromApn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (!self.receiveLogOutNotification) {
        
        
        if ( [LoginYesOrNoStr isEqualToString:@"YES"]) {
            CGPoint point = CGPointMake(self.didSegementIndex * ScreenWidth, 0);
            [self.scrollView setContentOffset:point animated:YES];
            [self.segemetnControl btnAction:self.segemetnControl.buttons[self.didSegementIndex]];
            
        }else {
            
            CGPoint point = CGPointMake(0 * ScreenWidth, 0);
            self.didSegementIndex = 0;
            [self.scrollView setContentOffset:point animated:YES];
            [self.segemetnControl btnAction:self.segemetnControl.buttons[0]];
            
        }
    } else {
        
        self.receiveLogOutNotification = NO;
        
    }
    


}


#pragma mark -- 添加子控制器
- (void)addChildViewControlers {
    
//    for (int i = 0; i<self.viewControllerNames.count; i++) {
//        UIViewController *ctl = [[NSClassFromString(self.viewControllerNames[i]) alloc] init];
//        [self addChildViewController:ctl];
//        if (i == 0) {
//            ctl.view.frame = self.scrollView.bounds;
//            [self.scrollView addSubview:ctl.view];
//        }
//    }
    
    ZYFoodViewController *foodVC = [[ZYFoodViewController alloc]init];
    [self addChildViewController:foodVC];
    foodVC.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:foodVC.view];

    
    ZYIntegralMainViewController *integralMainVC = [[ZYIntegralMainViewController alloc]initWithIsMain:YES];
    [self addChildViewController:integralMainVC];

}


#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    NSInteger index = scrollView.contentOffset.x / ScreenWidth + 0.5;
    
    [self showViewWithIndex:index];
    
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / ScreenWidth + 0.5;
    [self showViewWithIndex:index];
}


- (void)showViewWithIndex:(NSInteger)index {
    
    [self.segemetnControl btnAction:self.segemetnControl.buttons[index]];
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:vc.view];
    
  
    
    
}

#pragma mark -- WXSegementControlDelegate

-(void)segementControlDidSelectIndex:(NSInteger)index {
    NSDictionary *dic = @{@"index":@(index)};
    //发送通知 给 卖品 和 积分 控制器 设置导航栏的 透明度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZYallViewControllerDidSegemetnNotification" object:dic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
