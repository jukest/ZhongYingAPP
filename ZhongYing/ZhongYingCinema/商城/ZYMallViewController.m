//
//  ZYMallViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMallViewController.h"
#import "WXSegementControl.h"




@interface ZYMallViewController ()<WXSegementControlDelegate,UIScrollViewDelegate>

/**
 首页分页控件
 */
@property (nonatomic, strong) WXSegementControl *segemetnControl;
@property (nonatomic, strong) NSArray <NSString *> *segementControlTitles;

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray <NSString *>*viewControllerNames;


@end

@implementation ZYMallViewController


#pragma mark - 懒加载
- (WXSegementControl *)segemetnControl {
    
    if (!_segemetnControl) {
        _segemetnControl = [[WXSegementControl alloc]initWithFrame:CGRectMake(0, 0, 150, 30) withItems:self.segementControlTitles];
    }
    return _segemetnControl;
}

- (NSArray<NSString *> *)segementControlTitles {
    if (!_segementControlTitles) {
        _segementControlTitles = @[@"美食",@"会员卡"];
    }
    return _segementControlTitles;
}

- (NSMutableArray<NSString *> *)viewControllerNames {
    if (!_viewControllerNames) {
        _viewControllerNames = @[@"ZYFoodViewController",@"ZYMemberViewController"].mutableCopy;
    }
    return _viewControllerNames;
}


#pragma mark -- 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 -49)];
        _scrollView.contentSize = CGSizeMake(self.segementControlTitles.count * ScreenWidth, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return  _scrollView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segemetnControl;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    
    __weak typeof(self) weakSelf = self;
    self.segemetnControl.callBackBlock = ^(NSInteger index) {
        CGPoint point = CGPointMake(index * ScreenWidth, 0);
        [weakSelf.scrollView setContentOffset:point animated:YES];
    };

    [self addChildViewControlers];
    
    
    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);

}


#pragma mark -- 添加子控制器
- (void)addChildViewControlers {
    
    for (int i = 0; i<self.viewControllerNames.count; i++) {
        UIViewController *ctl = [[NSClassFromString(self.viewControllerNames[i]) alloc] init];
        [self addChildViewController:ctl];
        if (i == 0) {
            ctl.view.frame = self.scrollView.bounds;
            [self.scrollView addSubview:ctl.view];
        }
    }
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
