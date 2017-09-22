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
#import "LoginViewController.h"
#import "CinemaComplaintView.h"

@interface MainCimemaViewController ()<WXSegementControlDelegate,UIScrollViewDelegate,MainTableViewControllerDelegate,CinemaComplaintViewDelegate>{
    
    MBProgressHUD *_HUD1;
    
    
}

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


@property (nonatomic, strong) UIView *sugeestView;
@property (nonatomic, strong) CinemaComplaintView *complaintView;
@property (nonatomic, strong) UILabel *complaintLb;


@end

@implementation MainCimemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
    self.lastAlpha = 0;
    
    [self setup];
    [self setupLeftNavigationItem];
    
    //添加通知城市切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCityName:) name:PositionCityChangedNotification object:nil];

}




- (void)updateCityName:(NSNotification *)notification {
    NSLog(@"currentCityName%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityName"]);
    [self.leftButton setTitle:UserCurrentCityName forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [super viewWillDisappear:animated];
    self.navigationBarBackgroundView.alpha = 1;
    self.navigationController.navigationBar.barTintColor = Color(252, 186, 0, 1.0);
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

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
    
    //支付成功后从我的订单返回根控制器的操作
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
    
    [leftButton setTitle:UserCurrentCityName? UserCurrentCityName:@"定位" forState:UIControlStateNormal];

    [leftButton addTarget:self action:@selector(locationBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}


- (void)setup {
    
    
    [self.view addSubview:self.scrollView];
    
    [self addChildControl];
    
    [self addSegmentContro];
    
    [self addRightBarBtnItem];
    

    
}

- (void)addRightBarBtnItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.sugeestView];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)addSegmentContro {
    self.navigationItem.titleView = self.segemetnControl;
    self.segemetnControl.hidden = YES;

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

- (UIView *)sugeestView {
    if (!_sugeestView) {
//        CGSize complaintSize = [@"反馈与建议" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];

        _sugeestView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, 60, 40) backgroundColor:[UIColor clearColor]];
       
        UILabel *complaintLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10, 0, 100, 40) text:@"反馈" font:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        complaintLb.backgroundColor = [UIColor clearColor];
        self.complaintLb = complaintLb;
        [_sugeestView addSubview:complaintLb];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(complaintBtnDidClicked:)];
        [_sugeestView addGestureRecognizer:tap];
    }
    return _sugeestView;
}

- (NSArray<NSString *> *)segementControlTitles {
    if (!_segementControlTitles) {
        _segementControlTitles = @[@"电影",@"影院"];
    }
    return _segementControlTitles;
}

- (WXSegementControl *)segemetnControl {
    
    if (!_segemetnControl) {
        _segemetnControl = [[WXSegementControl alloc]initWithFrame:CGRectMake(0, 0, 120, 30) withItems:self.segementControlTitles];
        _segemetnControl.delegate = self;
//        [_segemetnControl setTitleColor:[UIColor redColor] forState:UIControlStateSelected forIndex:0];
//        [_segemetnControl setBackgroundColor:Color(123, 116, 133, 0.4) forIndex:1];
//        [_segemetnControl setSelectedBackgroundColor:Color(123, 116, 133, 1) forIndex:1];
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
    
    
//    if (index == 1) {
//        self.segemetnControl.buttons[index].backgroundColor = Color(123, 116, 133, 1);
//    } else if(index == 0) {
//        self.segemetnControl.buttons[index].backgroundColor = Color(123, 116, 133, 0.4);
//
//    }
    
//    //获取子控制器
    UIViewController *childController = self.childViewControllers[index];
    
    childController.view.frame = CGRectMake(index * ScreenWidth, 0, ScreenWidth, ScreenHeight - 49);
    
    [self.scrollView addSubview:childController.view];
    CGPoint offSet = CGPointMake(index *ScreenWidth, 0);
    [self.scrollView setContentOffset:offSet animated:YES];
    
    
    if (index == 0) {
        [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"down_1"] forState:UIControlStateNormal];
        self.complaintLb.textColor = [UIColor whiteColor];
        
    } else {
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        self.complaintLb.textColor = [UIColor blackColor];


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


#pragma mark - view Handles
- (void)complaintBtnDidClicked:(UIGestureRecognizer *)tap
{
    
    NSLog(@"投诉");
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) { // 用户未登录
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
    }else{
        _complaintView = [[CinemaComplaintView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 240 * heightFloat)];
        _complaintView.delegate = self;
        [_complaintView show];
    }
}

#pragma mark - CinemaComplaintViewDelegate
- (void)sendComplaint:(NSString *)complaint
{
    [self keyBoardDown];
    
    if (complaint.length < 6) {
        [self showMessage:@"投诉至少6个字"];
    }else{
        if (_complaintView.complaintFld.text.length >= 6 && _complaintView.complaintFld.text.length <= 256) {
            
            _HUD1 = [FanShuToolClass createMBProgressHUDWithText:@"发送中..." target:self];
            [[UIApplication sharedApplication].keyWindow addSubview:_HUD1];
            
            NSLog(@"%@",complaint);
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserComplaintURL];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"token"] = ApiTokenStr;
            parameters[@"content"] = _complaintView.complaintFld.text;
            ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
            [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
                NSLog(@"sendComplaint >>>>>>>> %@",dataBack);
                if ([dataBack[@"code"] integerValue] == 0){
                    [self showMessage:@"投诉成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [_complaintView hiddenView];
                    });
                }
                [_HUD1 hideAnimated:YES];
            } failure:^(NSError *error) {
                [self showMessage:@"连接服务器失败!"];
                [_HUD1 hideAnimated:YES];
            }];
        }else{
            [self showMessage:@"投诉最多256个字"];
        }
    }
}

- (void)keyBoardDown
{
    [_complaintView.complaintFld resignFirstResponder];
}

- (void)showMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_complaintView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = 0 +90;
    hud.labelFont = [UIFont systemFontOfSize:15];
    [hud hide:YES afterDelay:1.0f];
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
