//
//  MovieDetailsViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieDetailsViewCtl.h"
#import "MovieReviewTableViewCell.h"
#import "MovieDetailsHeaderView.h"
#import "InfoDetailsShareView.h"
#import "CinemaCommentViewCtl.h"
#import "AlbumViewController.h"
#import "CinemaDetailsViewCtl.h"
#import "UIImageView+WebCache.h"
#import "Movie.h"
#import "MovieComment.h"
#import "Masonry.h"
#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WMPlayer.h"
#import "PictureView.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"

@interface MovieDetailsViewCtl ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MovieMessageViewDelegate,InfoDetailsShareViewDelegate,MovePictureSliderViewDelegate,WMPlayerDelegate>
{
    MovieDetailsHeaderView *_headerView;
    NSString *_description;
    UIButton *_buyBtn;
    NSArray *_picArr;
    UIImageView *_backgroundImage;
    UIView *_navigationBar;
    UIToolbar *_toolbar;
    MBProgressHUD *_HUD;
    MBProgressHUD *_collectHUD;
    UIView *_backView;
    BOOL isSmallScreen;
    NSString *_shareUrl;
    InfoDetailsShareView *_shareView;
}

@property(nonatomic,strong) Movie *movie;
@property(nonatomic,strong) NSDictionary *box_office;
@property(nonatomic,strong) NSMutableArray *comments;
@property(nonatomic,strong) WMPlayer *player;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) UILabel *titleLb;

@end

@implementation MovieDetailsViewCtl

- (void)dealloc {
    NSLog(@"被释放");
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color(239, 239, 239, 1.0);
    self.currentPage = 0;
    //背景图
    _backgroundImage = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) image:[UIImage imageNamed:@""] tag:232];
    [_backgroundImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,self.hotFilm.cover]] placeholderImage:[UIImage imageNamed:@""]];
    [self.view addSubview:_backgroundImage];
    
    //模糊效果
    _backView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 192 +64, ScreenWidth, ScreenHeight -192-64) backgroundColor:Color(239, 239, 239, 1.0)];
    [self.view addSubview:_backView];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _backgroundImage.frame.size.width, _backgroundImage.frame.size.height)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar = toolbar;
    [_backgroundImage addSubview:toolbar];
    
    _picArr = @[@"",@"",@"",@"",@"",@"",@""];
    _headerView = [[MovieDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 610 +64) pictures:_picArr Film:self.hotFilm type:self.type];
    _headerView.movieMessage.delegate = self;
//    _headerView.moviePicSlider.delegate = self;
    _headerView.pictureSliderView.delegate = self;
    self.movieDetailsTableView.tableHeaderView = _headerView;
    
    _buyBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, ScreenHeight -54, ScreenWidth, 54) title:@"立即购票" titleColor:[UIColor whiteColor] target:self action:@selector(gotoMovieDetailsEvents:) tag:MovieDetailsBuyTicketEvent];
    _buyBtn.backgroundColor = Color(252, 186, 0, 1.0);
    [self.view addSubview:_buyBtn];
   
    isSmallScreen = NO;
    if ([self.type isEqualToString:@"预告片"]) {
        self.player.delegate = self;
    }
    [self customNavigationBar];
    
    if (!self.isApn) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    _shareUrl = [NSString stringWithFormat:@"%@User/Share/index/movie_id/%@/group_id/%@",BASE_URL,self.hotFilm.id,ApiGroup_ID];
    NSLog(@"%@",_shareUrl);
    [self loadMovie];
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    
    
    if (_player==nil||_player.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (self.player.isFullscreen) {
                if (isSmallScreen) {
                    //放widow上,小屏显示
                    [self toHeaderView];
                }else{
                    [self toHeaderView];
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            self.player.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            self.player.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if ([self.type isEqualToString:@"预告片"] && self.movie != 0) {
        //[self.player play];
    }
    if (self.isApn && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    [_headerView.pictureSliderView.adView play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.type isEqualToString:@"预告片"]) {
        [self.player pause];
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    if (_shareView != nil) {
        [_shareView hiddenView];
    }
    
    [_headerView.pictureSliderView.adView pause];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - help Methods
- (void)loadMovie
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonMovieURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }else{
        parameters[@"group_id"] = ApiGroup_ID;
        parameters[@"lng"] = ApiLngStr;
        parameters[@"lat"] = ApiLatStr;
    }
    parameters[@"movie_id"] = self.hotFilm.id;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @10;
    NSLog(@"%@",parameters);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getMovie>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            if (self.currentPage == 0) {
                NSError *error;
                self.movie = [[Movie alloc] initWithDictionary:content[@"movie"] error:&error];
                if (error) {
                    NSLog(@"movie_error = %@",error);
                }
                self.box_office = content[@"box_office"];
                for (NSDictionary *dict in content[@"comment"]) {
                    NSError *comment_error;
                    MovieComment *comment = [[MovieComment alloc] initWithDictionary:dict error:&comment_error];
                    if (comment_error) {
                        NSLog(@"comment_error = %@",comment_error);
                    }
                    [self.comments addObject:comment];
                }
                
                if ([content[@"movie"][@"picture"] isEqual:[NSNull null]]) {
                    _picArr = @[];
                    [self configHeaderViewWithHeight:610 +64];
                    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 610 +64 -154);
                    self.movieDetailsTableView.tableHeaderView = _headerView;
                }else{
                    [_headerView.movieMessage configMovieMessageViewWithModel:self.movie];
                    [_backgroundImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,self.movie.cover]] placeholderImage:[UIImage imageNamed:@""]];
//                    [_headerView.moviePicSlider configMoviePicSliderViewWithSliders:self.movie.picture];
                    [_headerView.pictureSliderView configMoviePicSliderViewWithSliders:self.movie.picture];
                    
                    [_headerView.movieBoxOffice configMovieBoxOfficeViewWithDictionary:self.box_office];
                    
                }
                
                if ([self.type isEqualToString:@"预告片"]) {
                    [self.player setURLString:[NSString stringWithFormat:@"%@%@",Image_URL,self.movie.trailer]];
                    [self.player play];
                    self.titleLb.text = self.hotFilm.name;
                }
                [self.movieDetailsTableView reloadData];
            }else{
                [self endRefresh];
                if ([content[@"comment"] count] != 0) {
                    for (NSDictionary *dict in content[@"comment"]) {
                        NSError *comment_error;
                        MovieComment *comment = [[MovieComment alloc] initWithDictionary:dict error:&comment_error];
                        if (comment_error) {
                            NSLog(@"comment_error = %@",comment_error);
                        }
                        [self.comments addObject:comment];
                    }
                    [self.movieDetailsTableView reloadData];
                }else{
                    self.currentPage --;
                }
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
            [self endRefresh];
            self.currentPage --;
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [self endRefresh];
        self.currentPage --;
        [_HUD hide:YES];
    }];
}

- (void)customNavigationBar
{
    UIColor *color = [UIColor whiteColor];
    UIView *navigationBar = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 64) backgroundColor:[color colorWithAlphaComponent:0]];
    [self.view addSubview:navigationBar];
    NSString *titleName;
    if ([self.type isEqualToString:@"预告片"]) {
        titleName = self.hotFilm.name;
    }else{
        titleName = @"电影";
    }
    UILabel *title = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 20, ScreenWidth -80, 44) text:titleName font:[UIFont fontWithName:@"Arial-BoldMT" size:20] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    title.center = CGPointMake(ScreenWidth / 2, 22 +20);
    self.titleLb = title;
    [navigationBar addSubview:title];
    
    UIButton *backBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12, 42, 20, 40) image:[UIImage imageNamed:@"movie_back"] target:nil action:nil tag:666];
    backBtn.center = CGPointMake(10 +10, 22 +20);
    [navigationBar addSubview:backBtn];
    
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, 100, 64) backgroundColor:[UIColor clearColor]];
    [navigationBar addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonDidClicked:)];
    [view addGestureRecognizer:tap];
    
    UIButton *share = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -30 -12, 20, 30, 20) image:[UIImage imageNamed:@"share"] target:self action:@selector(gotoMovieDetailsEvents:) tag:MovieDetailsShareEvent];
    share.center = CGPointMake(ScreenWidth -12 -15, 22 +20);
    [navigationBar addSubview:share];
    
    _navigationBar = navigationBar;
    
}

- (void)endRefresh
{
    if (self.movieDetailsTableView.mj_footer.isRefreshing) {
        [self.movieDetailsTableView.mj_footer endRefreshing];
    }
}

- (void)addRefreshView
{
    __weak MovieDetailsViewCtl *movie = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.movieDetailsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage ++;
        [movie loadMovie];
    }];
    
    //[self hideRefreshViewsubViews:self.cinemaTableView];
}

/**
 收藏影片
 */
- (void)collectMovie
{
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
    }else{
        _collectHUD = [FanShuToolClass createMBProgressHUDWithText:@"" target:self];
        [self.view addSubview:_collectHUD];
        
        NSString *urlStr;
        if (!_headerView.movieMessage.collectBtn.selected) {
            urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMovieCollectionURL];
            _collectHUD.labelText = @"收藏中...";
        }else{
            urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserCancelCollectionURL];
            _collectHUD.labelText = @"取消收藏中...";
        }
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        parameters[@"movie_id"] = @(self.movie.id);
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            NSLog(@"getUserStar >>>>>>>> %@",dataBack);
            if ([dataBack[@"code"] integerValue] == 0) {
                if (!_headerView.movieMessage.collectBtn.selected) {
                    [self showHudMessage:@"收藏成功"];
                    
                }else{
                    [self showHudMessage:@"取消收藏成功"];
                }
                _headerView.movieMessage.collectBtn.selected = !_headerView.movieMessage.collectBtn.selected;
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
            [_collectHUD hide:YES];
        } failure:^(NSError *error) {
            [self showHudMessage:@"连接服务器失败!"];
            [_collectHUD hide:YES];
        }];
    }
}

#pragma mark - 懒加载
- (UITableView *)movieDetailsTableView
{
    if (_movieDetailsTableView == nil) {
        _movieDetailsTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  -54) style:UITableViewStyleGrouped target:self];
        [_movieDetailsTableView registerClass:[MovieReviewTableViewCell class] forCellReuseIdentifier:@"MovieReviewTableViewCell"];
        //_movieDetailsTableView.backgroundView = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) image:[UIImage imageNamed:@"movie_poster_1"] tag:232];
        _movieDetailsTableView.backgroundColor = [UIColor clearColor];
        [self addRefreshView];
        [self.view addSubview:_movieDetailsTableView];
    }
    return _movieDetailsTableView;
}

- (NSMutableArray *)comments
{
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (WMPlayer *)player
{
    if (_player == nil) {
        _player = [[WMPlayer alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 192 +64)];
        _player.backgroundColor = [UIColor clearColor];
        _player.topView.hidden = YES;
        [self.view bringSubviewToFront:_navigationBar];
        [self.view addSubview:_player];
    }
    return _player;
}

#pragma mark - view handle
- (void)gotoMovieDetailsEvents:(UIButton *)btn
{
    if (btn.tag == MovieDetailsShareEvent) {
        NSLog(@"分享");
        InfoDetailsShareView *shareView = [[InfoDetailsShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        _shareView = shareView;
        shareView.delegate = self;
        [shareView show];
    }else if (btn.tag == MovieDetailsBuyTicketEvent){
        NSLog(@"立即购票");
        CinemaDetailsViewCtl *cinemaDetails = [[CinemaDetailsViewCtl alloc] init];
        cinemaDetails.cinemaMsg = self.cinemaMsg;
        cinemaDetails.filmsArr = self.filmsArr;
        cinemaDetails.film = self.hotFilm;
        cinemaDetails.indexPath = self.indexPath;
        [cinemaDetails setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cinemaDetails animated:YES];
    }
}

- (void)backButtonDidClicked:(UIGestureRecognizer *)tap
{
    if (_player != nil) {
        [self releaseWMPlayer];
        
    }
    if (!self.isApn) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFromApn"];
    }
}

/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    //堵塞主线程
    //    [wmPlayer.player.currentItem cancelPendingSeeks];
    //    [wmPlayer.player.currentItem.asset cancelLoading];
    [self.player pause];
    
    
    [self.player removeFromSuperview];
    [self.player.playerLayer removeFromSuperlayer];
    [self.player.player replaceCurrentItemWithPlayerItem:nil];
    self.player.player = nil;
    self.player.playerLayer = nil;
    self.player.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.player.autoDismissTimer invalidate];
    self.player.autoDismissTimer = nil;
    
    
    self.player.playOrPauseBtn = nil;
    self.player.playerLayer = nil;
    self.player = nil;
}

#pragma mark - MoviePicSliderViewDelegate
// 更多图片
- (void)jumpToMoviePicSliderViewEvents:(MoviePicSliderViewEvents)event
{
    if (event == MoreMoviePicEvent) {
        AlbumViewController *album = [[AlbumViewController alloc] init];
        album.pictures = self.movie.picture;
        album.name = self.movie.name;
        [album setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:album animated:YES];
    }
}

// 查看图片
- (void)jumpToPictureClickEvent:(NSInteger)index
{
    NSLog(@"%zd",index);
    PictureView *pictureView = [[PictureView alloc] initWithFrame:self.view.bounds WithUrlStr:self.movie.picture[index] Sliders:self.movie.picture Index:index];
    
    [pictureView show];
}

#pragma mark - InfoDetailsShareViewDelegate
- (void)jumpToShareView:(InfoDeatilsShareViewEvents)events
{
    UMSocialPlatformType type;
    if (events == WeChatFriendsShare) {
        NSLog(@"微信分享");
        type = UMSocialPlatformType_WechatSession;
    }else if (events == WeChatFriendsCircleShare){
        NSLog(@"朋友圈分享");
        type = UMSocialPlatformType_WechatTimeLine;
    }else if (events == QQFriendsShare){
        NSLog(@"QQ好友分享");
        type = UMSocialPlatformType_QQ;
    }else if (events == QzoneShare){
        NSLog(@"QQ空间分享");
        type = UMSocialPlatformType_Qzone;
    }else{
        NSLog(@"微博分享");
        type = UMSocialPlatformType_Sina;
    }
    [self shareTextToPlatformType:type];
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,self.hotFilm.cover]]];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.hotFilm.name descr:[NSString stringWithFormat:@"%@",_shareUrl] thumImage:[UIImage imageWithData:data]];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@",_shareUrl];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            if (platformType == UMSocialPlatformType_QQ || platformType == UMSocialPlatformType_Qzone) {
                if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                    [self showHudMessage:@"你没有安装QQ客户端"];
                }else{
                    
                }
            }else if(platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine){
                if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                    [self showHudMessage:@"你没有安装微信客户端"];
                }else{
                    
                }
            }
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

#pragma mark - MovieMessageViewDelegate
- (void)jumpToMovieMessageViewEvent:(MovieMessageViewEvents)event
{
    if (event == MoreDescriptionEvent) {
        NSLog(@"更多描述");
        
        CGSize descriptionSize = [FanShuToolClass createString:self.movie.detail font:[UIFont systemFontOfSize:16] lineSpacing:6 maxSize:CGSizeMake(ScreenWidth -32, ScreenHeight)];
        CGFloat height;
        if (_headerView.movieMessage.moreBtn.selected) {
            height = 610 +64 +descriptionSize.height -70;
        }else{
            height = 610 + 64;
        }
        [self configHeaderViewWithHeight:height];
        if (_picArr.count == 0) {
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, height -155);
            self.movieDetailsTableView.tableHeaderView = _headerView;
        }
    }else if (event == MovieCollectEvent){
        NSLog(@"收藏");
        [self collectMovie];
    }else if (event == MovieCommentEvent){
        NSLog(@"我要评论");
        if (![LoginYesOrNoStr isEqualToString:@"YES"]) { // 用户未登录
            LoginViewController *login = [[LoginViewController alloc] init];
            [login setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:login animated:YES];
        }else{
            CinemaCommentViewCtl *cinemaComment = [[CinemaCommentViewCtl alloc] init];
            cinemaComment.name = self.movie.name;
            cinemaComment.id = [NSString stringWithFormat:@"%zd",self.movie.id];
            cinemaComment.type = @"电影评论";
            cinemaComment.block = ^void(MovieComment *comment){
                [self.comments addObject:comment];
                [self.movieDetailsTableView reloadData];
            };
            [cinemaComment setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:cinemaComment animated:YES];
        }
    }else if (event == MovieMessageViewPlayEvents){//播放
        NSLog(@"播放");
        self.type = @"预告片";
        _headerView.movieMessage.backgroundView.hidden = YES;
        [self.player setURLString:[NSString stringWithFormat:@"%@%@",Image_URL,self.movie.trailer]];
        self.player.delegate = self;
        [self.player play];
        self.titleLb.text = self.hotFilm.name;
        [self.view bringSubviewToFront:_navigationBar];
    }
}

- (void)configHeaderViewWithHeight:(CGFloat)height
{
    _headerView = [[MovieDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height) pictures:_picArr Film:self.hotFilm type:self.type];
    [_headerView.movieMessage configMovieMessageViewWithModel:self.movie];
//    [_headerView.moviePicSlider configMoviePicSliderViewWithSliders:self.movie.picture];
    [_headerView.pictureSliderView configMoviePicSliderViewWithSliders:self.movie.picture];
    [_headerView.movieBoxOffice configMovieBoxOfficeViewWithDictionary:self.box_office];
    _headerView.movieMessage.delegate = self;
    _headerView.pictureSliderView.delegate = self;
    self.movieDetailsTableView.tableHeaderView = _headerView;
    [self.movieDetailsTableView reloadData];
    if ([self.type isEqualToString:@"预告片"]) {
        //_headerView.movieMessage.hidden = YES;
        [self.view bringSubviewToFront:self.player];
        [self.view bringSubviewToFront:_navigationBar];
    }
}

// 全屏
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [self.player removeFromSuperview];
    self.player.transform = CGAffineTransformIdentity;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.player.topView.hidden = NO;
    
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.player.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.player.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    self.player.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.player.playerLayer.frame =  CGRectMake(0,0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width);
    self.player.closeBtn.hidden = NO;
    
    [self.player.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.left.equalTo(self.player).with.offset(0);
        make.top.equalTo(self.player).with.offset(0);
    }];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        self.player.effectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height/2-155/2, [UIScreen mainScreen].bounds.size.width/2-155/2, 155, 155);
    }else{
        //        wmPlayer.lightView.frame = CGRectMake(kScreenHeight/2-155/2, kScreenWidth/2-155/2, 155, 155);
    }
    [self.player.FF_View  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player).with.offset([UIScreen mainScreen].bounds.size.height/2-120/2);
        make.top.equalTo(self.player).with.offset([UIScreen mainScreen].bounds.size.width/2-60/2);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(120);
    }];
    [self.player.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
        make.bottom.equalTo(self.player.contentView).with.offset(0);
    }];
    
    [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.left.equalTo(self.player).with.offset(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];
    
    [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.player).with.offset(20);
        
    }];
    
    [self.player.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(45);
        make.right.equalTo(self.player.topView).with.offset(-45);
        make.center.equalTo(self.player.topView);
        make.top.equalTo(self.player.topView).with.offset(0);
    }];
    
    [self.player.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player).with.offset(0);
        make.top.equalTo(self.player).with.offset([UIScreen mainScreen].bounds.size.width/2-30/2);
        make.height.equalTo(@30);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];
    
    [self.player.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player).with.offset([UIScreen mainScreen].bounds.size.height/2-22/2);
        make.top.equalTo(self.player).with.offset([UIScreen mainScreen].bounds.size.width/2-22/2);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    [self.view addSubview:self.player];
    [[UIApplication sharedApplication].keyWindow addSubview:self.player];
    self.player.fullScreenBtn.selected = YES;
    self.player.isFullscreen = YES;
    self.player.FF_View.hidden = YES;
}

-(void)toHeaderView{
    
    [self.player removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.player.topView.hidden = YES;
    
    [UIView animateWithDuration:0.7f animations:^{
        self.player.transform = CGAffineTransformIdentity;
        self.player.frame = CGRectMake(0, 0, ScreenWidth, 192 +64);
        self.player.playerLayer.frame =  self.player.bounds;
        [self.view addSubview:self.player];
        [self.view bringSubviewToFront:self.player];
        [self.player.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.player).with.offset(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(self.player.frame.size.height);
            
        }];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            self.player.effectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-155/2, [UIScreen mainScreen].bounds.size.height/2-155/2, 155, 155);
        }else{
            
        }
        
        [self.player.FF_View  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake([UIScreen mainScreen].bounds.size.width/2-180, self.player.frame.size.height/2-144));
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(120);
            
        }];
        
        [self.player.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(0);
            make.right.equalTo(self.player).with.offset(0);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(self.player).with.offset(0);
        }];
        [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(0);
            make.right.equalTo(self.player).with.offset(0);
            make.height.mas_equalTo(70);
            make.top.equalTo(self.player).with.offset(0);
        }];
        [self.player.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player.topView).with.offset(45);
            make.right.equalTo(self.player.topView).with.offset(-45);
            make.center.equalTo(self.player.topView);
            make.top.equalTo(self.player.topView).with.offset(0);
        }];
        [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(self.player).with.offset(20);
        }];
        [self.player.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.player);
            make.width.equalTo(self.player);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        self.player.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.player.fullScreenBtn.selected = NO;
        self.player.FF_View.hidden = YES;
        [self.view bringSubviewToFront:self.player];
        [self.view bringSubviewToFront:_navigationBar];
    }];
    
    
}

#pragma mark - WMPlayerDelegate
//点击全屏按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn
{
    NSLog(@"全屏");
    if (fullScreenBtn.isSelected) {//全屏显示
        self.player.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        //if (isSmallScreen) {
        //放widow上,小屏显示
        [self toHeaderView];
    }
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn
{
    [self toHeaderView];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isApn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFromApn"];
    }
    if (_player != nil) {
        [self releaseWMPlayer];
    }
    return YES;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.comments.count == 0) {
        return nil;
    }
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 30) backgroundColor:[UIColor whiteColor]];
    NSString *text = [NSString stringWithFormat:@"用户评论（%zd条）",self.comments.count];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    UILabel *count = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 0, textSize.width, 30) text:text font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [view addSubview:count];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieComment *comment = _comments[indexPath.row];
    CGSize commentSize = [FanShuToolClass createString:comment.content font:[UIFont systemFontOfSize:16] lineSpacing:5 maxSize:CGSizeMake(ScreenWidth -100, ScreenHeight)];
    
    return 70 +commentSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.comments.count == 0) {
        return 0.0001f;
    }
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieReviewTableViewCell"];
    MovieComment *comment = self.comments[indexPath.row];
    [cell configCellWithComment:comment];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _toolbar.frame = _backgroundImage.bounds;
    if ([self.type isEqualToString:@"海报"]) {
        
        UIColor *color = Color(252, 186, 0, 1.0);
        _navigationBar.backgroundColor = [color colorWithAlphaComponent:scrollView.contentOffset.y / 100];
    }
    
    CGRect oldBackView;
    oldBackView.origin.x = 0;
    oldBackView.origin.y = 192 +64 -scrollView.contentOffset.y;
    oldBackView.size.width = ScreenWidth;
    oldBackView.size.height = ScreenHeight -192-64 +scrollView.contentOffset.y;
    _backView.frame = oldBackView;
    if ([self.type isEqualToString:@"预告片"] && scrollView.contentOffset.y < 0) {
        self.movieDetailsTableView.bounces = NO;
    }
    if (scrollView.contentOffset.y > 0) {
        self.movieDetailsTableView.bounces = YES;
    }
}

@end
