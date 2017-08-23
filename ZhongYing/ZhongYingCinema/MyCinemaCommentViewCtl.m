//
//  MyCinemaCommentViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/11.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "MyCinemaCommentViewCtl.h"
#import "CinemaComment.h"
#import "CinemaCommentCell.h"

@interface MyCinemaCommentViewCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_headerView;
    UIView *_bottomView;
    NSInteger _index;
    MBProgressHUD *_HUD;
    MBProgressHUD *_deleteHUD;
    UIView *_editView;
    UIButton *_allBtn; //!<<全选按钮
    UIButton *_deleteBtn; //!<<删除按钮
    BOOL _isEditing;
}
@property(nonatomic,strong) NSMutableArray *cinemaComments; // 影院
@property(nonatomic,strong) NSMutableArray *deleteComments;  // 要删除的评论
@property(nonatomic,strong) NSMutableArray *deleteIndexPath;
@property(nonatomic,assign) NSInteger currentPage;

@end

@implementation MyCinemaCommentViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myCinemaCommentTableView.tableHeaderView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 15) backgroundColor:[UIColor clearColor]];
    
    [self setupEditView];
    [self loadMyCinemaCommentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Load
- (UITableView *)myCinemaCommentTableView
{
    if (_myCinemaCommentTableView == nil) {
        _myCinemaCommentTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- 64 -50) style:UITableViewStyleGrouped target:self];
        [_myCinemaCommentTableView registerClass:[CinemaCommentCell class] forCellReuseIdentifier:@"myCinemaCommentTableViewCell"];
        [self addRefreshView];
        [self.view addSubview:_myCinemaCommentTableView];
    }
    return _myCinemaCommentTableView;
}

- (NSMutableArray *)cinemaComments
{
    if (_cinemaComments == nil) {
        _cinemaComments = [NSMutableArray array];
    }
    return _cinemaComments;
}

- (NSMutableArray *)deleteComments
{
    if (_deleteComments == nil) {
        _deleteComments = [NSMutableArray array];
    }
    return _deleteComments;
}

- (NSMutableArray *)deleteIndexPath
{
    if (_deleteIndexPath == nil) {
        _deleteIndexPath = [NSMutableArray array];
    }
    return _deleteIndexPath;
}

#pragma mark - View Handle
- (void)gotoEdit:(UIButton *)btn
{
    [self.deleteComments removeAllObjects];
    [self.deleteIndexPath removeAllObjects];
    _isEditing = !_isEditing;
    self.myCinemaCommentTableView.editing = !self.myCinemaCommentTableView.editing;
    _allBtn.selected = NO;
    [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.enabled = NO;
    if (_isEditing) {
        _editView.hidden  = NO;
        self.myCinemaCommentTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -64 -50 -45);
    }else{
        _editView.hidden = YES;
        self.myCinemaCommentTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -64 -50);
    }
}

#pragma mark - Load Comments
/**
 获取影院评论列表
 */
- (void)loadMyCinemaCommentList
{
    if (_myCinemaCommentTableView != nil && (_myCinemaCommentTableView.mj_header.isRefreshing||_myCinemaCommentTableView.mj_footer.isRefreshing)) {
        
    }else{
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMyCinemaCommentListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        [self hideEditView];
        
        [self endRefreshing];
        if (self.currentPage == 0) {
            [self.cinemaComments removeAllObjects];
        }
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                CinemaComment *comment = [[CinemaComment alloc] initWithDictionary:dict error:&error];
                [self.cinemaComments addObject:comment];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (self.currentPage == 0) {
                [self.parentViewController showHudMessage:@"你还没有评论信息!"];
            }else{
                [self.parentViewController showHudMessage:@"没有更多了!"];
            }
        }else{
            [self.parentViewController showHudMessage:dataBack[@"message"]];
        }
        if (self.currentPage == 0) {
            [self.myCinemaCommentTableView setContentOffset:CGPointMake(0,0) animated:NO];
        }
        [self.myCinemaCommentTableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self.parentViewController showHudMessage:@"连接服务器失败!"];
        [self endRefreshing];
        [_HUD hide:YES];
    }];
}

#pragma mark - Help Methods
- (void)addRefreshView
{
    __weak MyCinemaCommentViewCtl *cinema = self;
    self.myCinemaCommentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        cinema.currentPage = 0;
        [cinema loadMyCinemaCommentList];
    }];
    
    self.myCinemaCommentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        cinema.currentPage ++;
        [cinema loadMyCinemaCommentList];
    }];
    
    //[self hideRefreshViewsubViews:self.CommentTableView];
}

/**
 结束上下拉刷新
 */
- (void)endRefreshing
{
    if (self.currentPage == 0) {
        [self.myCinemaCommentTableView.mj_header endRefreshing];
    }else {
        [self.myCinemaCommentTableView.mj_footer endRefreshing];
    }
}

- (void)setupEditView
{
    _editView = [FanShuToolClass createViewWithFrame:CGRectMake(0, ScreenHeight -50 -64 -45, ScreenWidth, 45) backgroundColor:[UIColor whiteColor]];
    _editView.layer.borderWidth = 1.0f;
    _editView.layer.borderColor = Color(193, 193, 193, 1.0).CGColor;
    [self.view addSubview:_editView];
    
    UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake((ScreenWidth -1)/ 2, 5, 1, 35) backgroundColor:Color(201, 201, 201, 1.0)];
    [_editView addSubview:line];
    
    //Color(245, 63, 91, 1.0)
    NSArray *titles = @[@"全选",@"删除"];
    NSArray *colors = @[Color(42, 42, 42, 1.0),Color(189, 189, 189, 1.0)];
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth / 2 * i, 0, (ScreenWidth -1)/ 2, 45) title:titles[i] titleColor:colors[i] target:self action:@selector(gotoMyBillEvents:) tag:333+i];
        [_editView addSubview:btn];
        if (i == 0) {
            _allBtn = btn;
            [btn setTitle:@"取消全选" forState:UIControlStateSelected];
        }else{
            _deleteBtn = btn;
            _deleteBtn.enabled = NO;
        }
    }
    _editView.hidden = YES;
}

- (void)hideEditView
{
    [self.deleteComments removeAllObjects];
    [self.deleteIndexPath removeAllObjects];
    _allBtn.selected = NO;
    self.myCinemaCommentTableView.editing = NO;
    [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.enabled = NO;
    _editView.hidden = YES;
    _isEditing = NO;
    self.myCinemaCommentTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -64 -50);
}

- (void)initDeleteUI
{
    [self.deleteComments removeAllObjects];
    [self.deleteIndexPath removeAllObjects];
    _allBtn.selected = NO;
    [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.enabled = NO;
}

- (void)gotoMyBillEvents:(UIButton *)btn
{
    if (btn.tag == 333) { // 全选
        [self.deleteComments removeAllObjects];
        [self.deleteIndexPath removeAllObjects];
        NSArray *commentArr;
        commentArr = self.cinemaComments;
        if (!btn.selected) {
            btn.selected = YES;
            for (int i = 0; i < commentArr.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.deleteIndexPath addObject:indexPath];
                [self.myCinemaCommentTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            }
            [self.deleteComments addObjectsFromArray:commentArr];
            [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteComments.count] forState:UIControlStateNormal];
            _deleteBtn.enabled = YES;
        }else{
            btn.selected = NO;
            [self.deleteComments removeAllObjects];
            for (int i = 0; i < commentArr.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.deleteIndexPath removeObject:indexPath];
                [self.myCinemaCommentTableView deselectRowAtIndexPath:indexPath animated:NO];
                //            cell.selected = NO;
            }
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }
    }else{ //删除
        [self deleteCinemaComment];
    }
}

/**
 删除影院评论
 
 */
- (void)deleteCinemaComment
{
    if (!_deleteHUD) {
        _deleteHUD = [FanShuToolClass createMBProgressHUDWithText:@"删除中..." target:self];
        [self.view addSubview:_deleteHUD];
    }else{
        _deleteHUD.labelText = @"删除中...";
        _deleteHUD.mode = MBProgressHUDModeIndeterminate;
        [_deleteHUD show:YES];
    }
    NSMutableArray *comments = [NSMutableArray array];
    for (CinemaComment *comment in self.deleteComments) {
        [comments addObject:comment.id];
    }
    NSString *comment_id = [comments componentsJoinedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserDeleteCinemaCommentURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"comment_id"] = comment_id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            [self.cinemaComments removeObjectsInArray:self.deleteComments];
            
            [self.myCinemaCommentTableView beginUpdates];
            [self.myCinemaCommentTableView deleteRowsAtIndexPaths:self.deleteIndexPath withRowAnimation:UITableViewRowAnimationFade];
            [self.myCinemaCommentTableView endUpdates];
            
            [self hideEditView];
            _deleteHUD.mode = MBProgressHUDModeCustomView;
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _deleteHUD.customView = [[UIImageView alloc] initWithImage:image];
            // Looks a bit nicer if we make it square.
            _deleteHUD.square = YES;
            // Optional label text.
            _deleteHUD.labelText = @"删除成功";
            
            [_deleteHUD hide:YES afterDelay:0.5];
        }else{
            [self.parentViewController showHudMessage:dataBack[@"message"]];
            [_deleteHUD hide:YES];
        }
        
    } failure:^(NSError *error) {
        [self.parentViewController showHudMessage:@"连接服务器失败!"];
        [_deleteHUD hide:YES];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CinemaComment *comment = self.cinemaComments[indexPath.row];
    CGSize commentSize = [FanShuToolClass createString:comment.content font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -12 -45, ScreenHeight)];
    return 60 +commentSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.isEditing) {
        CinemaComment *comment = self.cinemaComments[indexPath.row];
        [self.deleteComments addObject:comment];
        [self.deleteIndexPath addObject:indexPath];
        [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
        [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteComments.count] forState:UIControlStateNormal];
        _deleteBtn.enabled = YES;
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        CinemaComment *comment = self.cinemaComments[indexPath.row];
        [self.deleteComments removeObject:comment];
        [self.deleteIndexPath removeObject:indexPath];
        if (self.deleteComments.count == 0) {
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }else{
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteComments.count] forState:UIControlStateNormal];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cinemaComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CinemaComment *comment = self.cinemaComments[indexPath.row];
    CinemaCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCinemaCommentTableViewCell"];
    [cell configCellWithModel:comment];
    return cell;
    
}

@end
