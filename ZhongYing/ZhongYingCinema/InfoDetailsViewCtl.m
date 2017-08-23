//
//  InfoDetailsViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "InfoDetailsViewCtl.h"
#import "InfoDetailsHeaderView.h"
#import "CommentTableViewCell.h"
#import "WriteCommentsView.h"
#import "InfoDetailsShareView.h"
#import "InfoComment.h"
#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface InfoDetailsViewCtl ()<UITableViewDelegate,UITableViewDataSource,WriteCommentsViewDelegate,InfoDetailsShareViewDelegate,InfoDetailsHeaderViewDelegate>
{
    InfoDetailsHeaderView *_headerView;
    WriteCommentsView *_writeView;
    MBProgressHUD *_HUD;
    MBProgressHUD *_HUD1;
    MBProgressHUD *_commentHUD;
    float _lastHeight;
    NSInteger _commentCount;
}
@property(nonatomic,strong) NSMutableDictionary *details;
@property(nonatomic,strong) NSMutableArray *comments;
@property(nonatomic,assign) NSInteger currentPage;

@end

@implementation InfoDetailsViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // 键盘
    [self registerLJWKeyboardHandler];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"资讯";
    UIButton *rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 24, 24) image:[UIImage imageNamed:@"share"] target:self action:@selector(gotoShareEvents:) tag:10001];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _commentCount = [self.news.comment integerValue];
    self.currentPage = 0;
    self.details = [NSMutableDictionary dictionaryWithDictionary:[self.news toDictionary]];
    [self initInfoDetailsUI];
    
    [self loadNewsDetails];
    [self loadNewsCommentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help Methods
/**
 结束上下拉刷新
 */
- (void)endRefreshing
{
    if (_detailsTableView != nil) {
        if (self.currentPage == 0) {
            [self.detailsTableView.mj_header endRefreshing];
        }else {
            [self.detailsTableView.mj_footer endRefreshing];
        }
    }
}

- (void)loadNewsDetails
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonNewsDetailURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }
    parameters[@"lng"] = ApiLngStr;
    parameters[@"lat"] = ApiLatStr;
    parameters[@"group_id"] = ApiGroup_ID;
    parameters[@"news_id"] = self.news.id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getNewsDetails >>>>>>>> %@",dataBack);
        self.details = [NSMutableDictionary dictionaryWithDictionary:dataBack[@"content"]];
        //[self initInfoDetailsUI];
        [_headerView configViewWithDetails:self.details];
        self.rateBlock([self.details[@"rate"] integerValue]);
        
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)loadNewsCommentList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiCommonNewsCommentListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ApiTokenStr) {
        parameters[@"token"] = ApiTokenStr;
    }
    parameters[@"lng"] = ApiLngStr;
    parameters[@"lat"] = ApiLatStr;
    parameters[@"group_id"] = ApiGroup_ID;
    parameters[@"news_id"] = self.news.id;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getNewsList >>>>>>>>>>> %@",dataBack);
        [self endRefreshing];
        if ([dataBack[@"code"] integerValue] == 0) {
            if (self.currentPage == 0) {
                [self.comments removeAllObjects];
            }
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                InfoComment *comment = [[InfoComment alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"%@",error);
                }
                [self.comments addObject:comment];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (self.currentPage != 0) {
                [self showHudMessage:@"没有更多了!"];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        if (_detailsTableView != nil) {
            [self.detailsTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [self endRefreshing];
    }];
}

- (void)initInfoDetailsUI
{
    CGSize titleSize = [FanShuToolClass createString:self.details[@"title"] font:[UIFont systemFontOfSize:18] lineSpacing:5 maxSize:CGSizeMake(ScreenWidth -30, ScreenHeight)];
    CGFloat H = 15 + titleSize.height + 20 +10 +15 +10;
    _lastHeight = H +500;
    _headerView = [[InfoDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _lastHeight) details:self.details];
    _headerView.userInteractionEnabled = NO;
    _headerView.delegate = self;
    self.detailsTableView.tableHeaderView = _headerView;
    
    if (_writeView == nil) {
        _writeView = [[WriteCommentsView alloc] initWithFrame:CGRectMake(0, ScreenHeight -58, ScreenWidth, 58)];
        _writeView.delegate = self;
        _writeView.layer.borderWidth = 0.8f;
        _writeView.layer.borderColor = Color(239, 239, 239, 1.0).CGColor;
        [self.view addSubview:_writeView];
    }
}

- (void)keyBoardDown
{
    [_writeView.writeCommentsTfd resignFirstResponder];
}

- (void)addRefreshView
{
    
    __weak InfoDetailsViewCtl *details = self;
    self.detailsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        details.currentPage = 0;
        [details loadNewsDetails];
        [details loadNewsCommentList];
    }];
    
    self.detailsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        details.currentPage ++;
        // [details loadNewsDetails];
        [details loadNewsCommentList];
    }];
    
    //[self hideRefreshViewsubViews:self.detailsTableView];
}

#pragma mark - View handle
- (void)gotoShareEvents:(UIBarButtonItem *)btn
{
    if ([_writeView.writeCommentsTfd isFirstResponder]) {
        [_writeView.writeCommentsTfd resignFirstResponder];
    }
    InfoDetailsShareView *shareView = [[InfoDetailsShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    shareView.delegate = self;
    [shareView show];
}

#pragma mark - 懒加载
- (UITableView *)detailsTableView
{
    if (_detailsTableView == nil) {
        _detailsTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -58) style:UITableViewStyleGrouped target:self];
        [_detailsTableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"InfoDetailsTableViewCell"];
        [self addRefreshView];
        [self.view addSubview:_detailsTableView];
    }
    return _detailsTableView;
}

- (NSMutableArray *)comments
{
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

#pragma mark - InfoDetailsHeaderViewDelegate
- (void)getContentHeight:(CGFloat)height
{
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, _lastHeight +height -500);
    self.detailsTableView.tableHeaderView = _headerView;
}

#pragma mark - WriteCommentsViewDelegate
- (void)sendComments:(NSString *)comments
{
    [self keyBoardDown];
    if (![LoginYesOrNoStr isEqualToString:@"YES"]) { // 用户未登录
        LoginViewController *login = [[LoginViewController alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
    }else{
        if (comments.length < 6) {
            [self showHudMessage:@"评论至少6个字"];
        }else{
            _commentHUD = [FanShuToolClass createMBProgressHUDWithText:@"发送中..." target:self];
            [self.view addSubview:_commentHUD];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserNewsCommentURL];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"token"] = ApiTokenStr;
            parameters[@"news_id"] = self.news.id;
            parameters[@"content"] = comments;
            ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
            [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
                if ([dataBack[@"code"] integerValue] == 0) {
                    //[self showHudMessage:@"评论成功"];
                    //                [self.comments removeAllObjects];
                    //                [self loadNewsCommentList];
                    InfoComment *comment = [[InfoComment alloc] init];
                    comment.avatar = ApiavatarStr;
                    comment.nickname = ApiNickNameStr;
                    comment.created_time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                    comment.content = comments;
                    [self.comments insertObject:comment atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.detailsTableView beginUpdates];
                    [self.detailsTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.detailsTableView endUpdates];
                    _writeView.writeCommentsTfd.text = @"";
                    _writeView.sendCommentsBtn.enabled = NO;
                    _writeView.sendCommentsBtn.backgroundColor = Color(204, 204, 204, 1.0);
                    
                    _commentHUD.mode = MBProgressHUDModeCustomView;
                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    _commentHUD.customView = [[UIImageView alloc] initWithImage:image];
                    // Looks a bit nicer if we make it square.
                    _commentHUD.square = YES;
                    // Optional label text.
                    _commentHUD.labelText = @"评论成功";
                    self.commentBlock(++_commentCount);
                    [_commentHUD hide:YES afterDelay:1.0];
                }else{
                    [self showHudMessage:dataBack[@"message"]];
                    [_commentHUD hide:YES];
                }
                
            } failure:^(NSError *error) {
                [self showHudMessage:@"连接服务器失败!"];
                [_commentHUD hide:YES];
            }];
        }
    }
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
    [self shareWebPageToPlatformType:type];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,self.news.cover]]];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.news.title descr:[NSString stringWithFormat:@"%@%@",BASE_URL,self.details[@"url"]] thumImage:[UIImage imageWithData:data]];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,self.details[@"url"]];
    
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoDetailsTableViewCell"];
    InfoComment *comment = self.comments[indexPath.row];
    [cell configCellWithModel:comment];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoComment *comment = self.comments[indexPath.row];
    CGSize commentSize = [FanShuToolClass createString:comment.content font:[UIFont systemFontOfSize:15] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -70 -20, ScreenHeight)];
    return 80 +commentSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.comments.count == 0) {
        return 0.00001f;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.comments.count == 0) {
        return nil;
    }
    UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 30) backgroundColor:Color(245, 245, 245, 1.0)];
    
    view.layer.borderColor = Color(234, 234, 234, 1.0).CGColor;
    UILabel *title = [FanShuToolClass createLabelWithFrame:CGRectMake(10, 0, 100, 20) text:@"最新评论" font:[UIFont systemFontOfSize:14] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
    title.center = CGPointMake(60, 15);
    [view addSubview:title];
    return view;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.isDragging) {
//
//    }
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_writeView.writeCommentsTfd resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
