//
//  MyCollectionViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyCollectionViewCtl.h"
#import "MyCollectionCell.h"
#import "MovieDetailsViewCtl.h"
#import "Collection.h"
@interface MyCollectionViewCtl ()
{
    MBProgressHUD *_HUD;
    MBProgressHUD *_deleteHUD;
    UIView *_editView;
    UIButton *_allBtn; //!<<全选按钮
    UIButton *_deleteBtn; //!<<删除按钮
    BOOL _isEditing;
}
@property(nonatomic,strong) NSMutableArray *collectionList;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray *deleteCollections;
@property(nonatomic,strong) NSMutableArray *deleteIndexPaths;

@end

@implementation MyCollectionViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的收藏";
    UIButton *rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 22, 20) image:[UIImage imageNamed:@"my_collection_delete"] target:self action:@selector(gotoMyCollectionEvent:) tag:100];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    _isEditing = NO;
    //[self.myCollectionTableView reloadData];
    _currentPage = 0;
    [self loadMyCollectionList];
    
    [self setupEditView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoMyCollectionEvent:(UIButton *)btn
{
    if (btn.tag == 100) {
        [self.deleteCollections removeAllObjects];
        [self.deleteIndexPaths removeAllObjects];
        _isEditing = !_isEditing;
        self.myCollectionTableView.editing = !self.myCollectionTableView.editing;
        _allBtn.selected = NO;
        [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.enabled = NO;
        if (_isEditing) {
            _editView.hidden  = NO;
            self.myCollectionTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64 -45);
        }else{
            _editView.hidden = YES;
            self.myCollectionTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64);
        }
    }
}

- (void)gotoMyBillEvents:(UIButton *)btn
{
    if (btn.tag == 333) { // 全选
        [self.deleteCollections removeAllObjects];
        [self.deleteIndexPaths removeAllObjects];
        if (!btn.selected) {
            btn.selected = YES;
            for (int i = 0; i < self.collectionList.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.deleteIndexPaths addObject:indexPath];
                [self.myCollectionTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            }
            [self.deleteCollections addObjectsFromArray:self.collectionList];
            [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteCollections.count] forState:UIControlStateNormal];
            _deleteBtn.enabled = YES;
        }else{
            btn.selected = NO;
            [self.deleteCollections removeAllObjects];
            for (int i = 0; i < self.collectionList.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.deleteIndexPaths removeObject:indexPath];
                [self.myCollectionTableView deselectRowAtIndexPath:indexPath animated:NO];
                //            cell.selected = NO;
            }
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }
    }else{ //删除
        [self deleteMyCollection];
    }
}

#pragma mark - help Methods
- (void)loadMyCollectionList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMyCollectionListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"page"] = @(self.currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getMyCollectonList >>>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"film"]) {
                NSError *error;
                Collection *collection = [[Collection alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"myCollection_error = %@",error);
                }
                [self.collectionList addObject:collection];
            }
            [self.myCollectionTableView reloadData];
        }else if([dataBack[@"code"] intValue] == 46005){
            [self showHudMessage:@"你还没有收藏的信息!"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [_HUD hide:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)deleteMyCollection
{
    if (!_deleteHUD) {
        _deleteHUD = [FanShuToolClass createMBProgressHUDWithText:@"删除中..." target:self];
        [self.view addSubview:_deleteHUD];
    }else{
        _deleteHUD.labelText = @"删除中...";
        _deleteHUD.mode = MBProgressHUDModeIndeterminate;
        [_deleteHUD show:YES];
    }
    NSMutableArray *cids = [NSMutableArray array];
    for (Collection *collection in self.deleteCollections) {
        [cids addObject:[NSString stringWithFormat:@"%zd",collection.id]];
    }
    NSString *cid = [cids componentsJoinedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserDeleteMyCollectionURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cid"] = cid;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getDeleteCollection>>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            [self.collectionList removeObjectsInArray:self.deleteCollections];
            
            [self.myCollectionTableView beginUpdates];
            [self.myCollectionTableView deleteRowsAtIndexPaths:self.deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.myCollectionTableView endUpdates];
            
            self.myCollectionTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64);
            [self.deleteCollections removeAllObjects];
            [self.deleteIndexPaths removeAllObjects];
            self.myCollectionTableView.editing = NO;
            _isEditing = NO;
            _editView.hidden  = YES;
            _allBtn.selected = NO;
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
            
            _deleteHUD.mode = MBProgressHUDModeCustomView;
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _deleteHUD.customView = [[UIImageView alloc] initWithImage:image];
            // Looks a bit nicer if we make it square.
            _deleteHUD.square = YES;
            // Optional label text.
            _deleteHUD.labelText = @"删除成功";
            
            [_deleteHUD hide:YES afterDelay:0.5];
        }else{
            [self showHudMessage:dataBack[@"message"]];
            [_deleteHUD hide:YES];
        }
    } failure:^(NSError *error) {
        [_deleteHUD hide:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)setupEditView
{
    _editView = [FanShuToolClass createViewWithFrame:CGRectMake(0, ScreenHeight -45, ScreenWidth, 45) backgroundColor:[UIColor whiteColor]];
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

#pragma mark - 懒加载
- (UITableView *)myCollectionTableView
{
    if (_myCollectionTableView == nil) {
        _myCollectionTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_myCollectionTableView registerClass:[MyCollectionCell class] forCellReuseIdentifier:@"MyCollectionCell"];
        _myCollectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myCollectionTableView];
    }
    return _myCollectionTableView;
}

- (NSMutableArray *)collectionList
{
    if (_collectionList == nil) {
        _collectionList = [NSMutableArray array];
    }
    return _collectionList;
}

- (NSMutableArray *)deleteCollections
{
    if (_deleteCollections == nil) {
        _deleteCollections = [NSMutableArray array];
    }
    return _deleteCollections;
}

- (NSMutableArray *)deleteIndexPaths
{
    if (_deleteIndexPaths == nil) {
        _deleteIndexPaths = [NSMutableArray array];
    }
    return _deleteIndexPaths;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 129;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Collection *collection = self.collectionList[indexPath.row];
    if (tableView.isEditing) {
        [self.deleteCollections addObject:collection];
        [self.deleteIndexPaths addObject:indexPath];
        [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
        [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteCollections.count] forState:UIControlStateNormal];
        _deleteBtn.enabled = YES;
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MovieDetailsViewCtl *movieDetails = [[MovieDetailsViewCtl alloc] init];
        HotFilm *film = [[HotFilm alloc] init];
        film.id = [NSString stringWithFormat:@"%zd",collection.movie_id];
        film.name = collection.name;
        film.tags = collection.tags;
        film.label = collection.label;
        film.cover = collection.cover;
        film.trailer = @"";
        movieDetails.type = @"海报";
        movieDetails.hotFilm = film;
        movieDetails.isApn = NO;
        [movieDetails setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:movieDetails animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        Collection *collection = self.collectionList[indexPath.row];
        [self.deleteCollections removeObject:collection];
        [self.deleteIndexPaths removeObject:indexPath];
        if (self.deleteCollections.count == 0) {
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }else{
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteCollections.count] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectionCell"];
    Collection *collection = self.collectionList[indexPath.row];
    [cell configCellWithModel:collection];
    return cell;
}

@end
