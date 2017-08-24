//
//  MainCimemaViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "MainCimemaViewController.h"
#import "WXSegementControl.h"
#import "MainTableViewController.h"
#import "MoreCinemaViewCtl.h"
#import "ZYCityManager.h"
#import "ZYPositionCityTableViewController.h"

@interface MainCimemaViewController ()<WXSegementControlDelegate,UIScrollViewDelegate,MainTableViewControllerDelegate>
@property (nonatomic, strong) WXSegementControl *segemetnControl;
@property (nonatomic, strong) NSArray <NSString *> *segementControlTitles;

@property (nonatomic, strong) UIScrollView *scrollView;

/**
 导航条的背景视图
 */
@property (nonatomic, weak) UIImageView *navigationBarBackgroundView;

/** 导航栏背景的透明度 */
@property (nonatomic, assign) CGFloat lastAlpha;

/** 导航栏左侧按钮 */
@property (nonatomic, strong) UIButton *leftButton;


@end

@implementation MainCimemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
    self.lastAlpha = 0;
    
    [self setup];
    [self setupLeftNavigationItem];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置

    self.navigationBarBackgroundView.alpha = 1;
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);    
    //设置透明的导航栏
    self.navigationController.navigationBar.translucent = YES;
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBarBackgroundView.alpha = self.lastAlpha;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - 初始化

- (void)setupLeftNavigationItem {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton = leftButton;
    leftButton.frame = CGRectMake(0, 0, 50, 30);
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton.titleLabel sizeToFit];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [leftButton setImage:[UIImage imageNamed:@"down_1"] forState:UIControlStateNormal];
    
    [leftButton setTitle:@"深圳市" forState:UIControlStateNormal];

    [leftButton addTarget:self action:@selector(locationBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
}


- (void)setup {
    
    
    [self.view addSubview:self.scrollView];
    
    [self addChildControl];
    
    [self addSegmentContro];

    
}

- (void)addSegmentContro {
    self.navigationItem.titleView = self.segemetnControl;
//    [self segementControlDidSelectIndex:0];

}

- (void)addChildControl {
   
    MainTableViewController *cinemaController = [[MainTableViewController alloc]init];
    cinemaController.delegate = self;
    [self addChildViewController:cinemaController];
    
    cinemaController.view.frame = CGRectMake(0 * ScreenWidth, 0, ScreenWidth, ScreenHeight - 49);
    [self.scrollView addSubview:cinemaController.view];
    
    

    
    MoreCinemaViewCtl *moreCinemaVC = [[MoreCinemaViewCtl alloc]init];
    moreCinemaVC.cinemaType = @"更多影院";
    [self addChildViewController:moreCinemaVC];
    
}

#pragma mark - 懒加载

- (NSArray<NSString *> *)segementControlTitles {
    if (!_segementControlTitles) {
        _segementControlTitles = @[@"电影",@"影院"];
    }
    return _segementControlTitles;
}

- (WXSegementControl *)segemetnControl {
    
    if (!_segemetnControl) {
        _segemetnControl = [[WXSegementControl alloc]initWithFrame:CGRectMake(0, 0, 150, 30) withItems:self.segementControlTitles];
        _segemetnControl.delegate = self;
    }
    return _segemetnControl;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)];
        _scrollView.contentSize = CGSizeMake(ScreenWidth * self.segementControlTitles.count, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}



#pragma mark - WXSegemetnControlDelegate

- (void)segementControlDidSelectIndex:(NSInteger)index {
    
    NSLog(@"%@",self.segementControlTitles[index]);
    
//    //获取子控制器
    UIViewController *childController = self.childViewControllers[index];
    
    childController.view.frame = CGRectMake(index * ScreenWidth, 0, ScreenWidth, ScreenHeight - 49);
    
    [self.scrollView addSubview:childController.view];
    CGPoint offSet = CGPointMake(index *ScreenWidth, 0);
    [self.scrollView setContentOffset:offSet animated:YES];
    
    
    if (index == 0) {
        [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"down_1"] forState:UIControlStateNormal];

        
    } else {
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];

    }
    
    
    
}

#pragma mark - CinemaViewControllerDelegate


- (void)mainTableViewController:(MainTableViewController *)mainTalbeViewController scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y;
    
    CGFloat alpha = (1 / (CinemaViewControllerHeaderScrollImageH - 64)) * offset;
    
    self.navigationBarBackgroundView.alpha = alpha;
    self.lastAlpha = alpha;
}

#pragma mark -定位按钮

- (void)locationBtn:(UIButton *)btn {
    
    NSLog(@"定位城市");
    __weak typeof(self) weakSelf = self;
    ZYPositionCityTableViewController *positionVC = [[ZYPositionCityTableViewController alloc]init];
    positionVC.title = @"城市切换";
    positionVC.positionBlock = ^(NSString *city) {
        [weakSelf.leftButton setTitle:city forState:UIControlStateNormal];
        
    };
    
    [positionVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:positionVC animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
