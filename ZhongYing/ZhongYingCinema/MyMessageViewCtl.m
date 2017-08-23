//
//  MyMessageViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyMessageViewCtl.h"
#import "MyMessageCell.h"
#import "MessageDetailsViewCtl.h"
#import "Message.h"
#import "UIImage+GIF.h"

@interface MyMessageViewCtl ()
{
    BOOL _isEditing;
    MBProgressHUD *_HUD;
    MBProgressHUD *_deleteHUD;
    UIButton *_rightBtn;
    UIView *_editView;
    UIButton *_allBtn; //!<<全选按钮
    UIButton *_deleteBtn; //!<<删除按钮
}
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray *messageList;
@property(nonatomic,strong) NSMutableArray *deleteIndexs;
@property(nonatomic,strong) NSMutableArray *deleteMessages;

@end

@implementation MyMessageViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    _rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:@"编辑" titleColor:[UIColor whiteColor] target:self action:@selector(myMessageEdit:) tag:100];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    _isEditing = NO;
    _currentPage = 0;
    
    [self setupEditView];
    [self loadMessageList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myMessageEdit:(UIButton *)btn
{
    if (btn.tag == 100) {
        
        [self.deleteMessages removeAllObjects];
        [self.deleteIndexs removeAllObjects];
        _isEditing = !_isEditing;
        self.myMessageTableView.editing = !self.myMessageTableView.editing;
        _allBtn.selected = NO;
        [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.enabled = NO;
        if (_isEditing) {
            _editView.hidden  = NO;
            self.myMessageTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64 -45);
        }else{
            _editView.hidden = YES;
            self.myMessageTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64);
        }
    }
}

#pragma mark - help method
- (void)loadMessageList
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMessageListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    parameters[@"page"] = @(_currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        [self endRefresh];
        if (self.currentPage == 0) {
            [self.messageList removeAllObjects];
            [self.deleteMessages removeAllObjects];
            [self.deleteIndexs removeAllObjects];
        }
        if ([dataBack[@"code"] integerValue] == 0) {
            
            if (self.currentPage == 0) {
                _allBtn.selected = NO;
                [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
                [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
                _deleteBtn.enabled = NO;
            }
            NSLog(@"getMessageList >>>>>>>>>>>>>>>>> %@",dataBack);
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Message *message = [[Message alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error:%@",error);
                }
                [self.messageList addObject:message];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (self.currentPage == 0) {
                [self showHudMessage:@"你还没有消息!"];
            }else{
                [self showHudMessage:@"没有更多了!"];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
            
        }
        [self.myMessageTableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self endRefresh];
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)deleteMessage
{
    if (!_deleteHUD) {
        _deleteHUD = [FanShuToolClass createMBProgressHUDWithText:@"删除中..." target:self];
        [self.view addSubview:_deleteHUD];
    }else{
        _deleteHUD.labelText = @"删除中...";
        _deleteHUD.mode = MBProgressHUDModeIndeterminate;
        [_deleteHUD show:YES];
    }
    NSMutableArray *cinema_ids = [NSMutableArray array];
    for (Message *message in self.deleteMessages) {
        [cinema_ids addObject:message.id];
    }
    NSString *message_id = [cinema_ids componentsJoinedByString:@","];
    NSLog(@"message_id ======= %@",message_id);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserDeleteMessageURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"message_id"] = message_id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            [self.messageList removeObjectsInArray:self.deleteMessages];
            
            [self.myMessageTableView beginUpdates];
            [self.myMessageTableView deleteRowsAtIndexPaths:self.deleteIndexs withRowAnimation:UITableViewRowAnimationFade];
            [self.myMessageTableView endUpdates];
            
            self.myMessageTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64);
            [self.deleteMessages removeAllObjects];
            [self.deleteIndexs removeAllObjects];
            self.myMessageTableView.editing = NO;
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
        [self showHudMessage:@"连接服务器失败!"];
        [_deleteHUD hide:YES];
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

- (void)gotoMyBillEvents:(UIButton *)btn
{
    if (btn.tag == 333) { // 全选
        [self.deleteMessages removeAllObjects];
        [self.deleteIndexs removeAllObjects];
        if (!btn.selected) {
            btn.selected = YES;
            for (int i = 0; i < self.messageList.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.deleteIndexs addObject:indexPath];
                [self.myMessageTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            }
            [self.deleteMessages addObjectsFromArray:self.messageList];
            [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteMessages.count] forState:UIControlStateNormal];
            _deleteBtn.enabled = YES;
        }else{
            btn.selected = NO;
            [self.deleteMessages removeAllObjects];
            for (int i = 0; i < self.messageList.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.deleteIndexs removeObject:indexPath];
                [self.myMessageTableView deselectRowAtIndexPath:indexPath animated:NO];
                //            cell.selected = NO;
            }
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }
    }else{ //删除
        [self deleteMessage];
    }
}

- (void)endRefresh
{
    if (self.myMessageTableView.mj_header.isRefreshing) {
        [self.myMessageTableView.mj_header endRefreshing];
    }
    if (self.myMessageTableView.mj_footer.isRefreshing) {
        [self.myMessageTableView.mj_footer endRefreshing];
    }
}

- (void)addRefreshView
{
    __weak MyMessageViewCtl *myMessage = self;
    self.myMessageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        myMessage.currentPage = 0;
        [myMessage loadMessageList];
    }];
    
    self.myMessageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        myMessage.currentPage ++;
        [myMessage loadMessageList];
    }];
    //[self hideRefreshViewsubViews:self.myMessageTableView];
}

#pragma mark - 懒加载

- (UITableView *)myMessageTableView
{
    if (_myMessageTableView == nil) {
        _myMessageTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped target:self];
        [_myMessageTableView registerClass:[MyMessageCell class] forCellReuseIdentifier:@"MyMessageCell"];
        [self addRefreshView];
        [self.view addSubview:_myMessageTableView];
    }
    return _myMessageTableView;
}

- (NSMutableArray *)messageList
{
    if (_messageList == nil) {
        _messageList = [NSMutableArray array];
    }
    return _messageList;
}

- (NSMutableArray *)deleteIndexs
{
    if (_deleteIndexs == nil) {
        _deleteIndexs = [NSMutableArray array];
    }
    return _deleteIndexs;
}

- (NSMutableArray *)deleteMessages
{
    if (_deleteMessages == nil) {
        _deleteMessages = [NSMutableArray array];
    }
    return _deleteMessages;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    Message *message = self.messageList[indexPath.row];
    if (tableView.isEditing) {
        [self.deleteMessages addObject:message];
        [self.deleteIndexs addObject:indexPath];
        [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
        [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteMessages.count] forState:UIControlStateNormal];
        _deleteBtn.enabled = YES;
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MessageDetailsViewCtl *messageDetails = [[MessageDetailsViewCtl alloc] init];
        messageDetails.message = message;
        [messageDetails setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:messageDetails animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        Message *message = self.messageList[indexPath.row];
        [self.deleteMessages removeObject:message];
        [self.deleteIndexs removeObject:indexPath];
        if (self.deleteMessages.count == 0) {
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }else{
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteMessages.count] forState:UIControlStateNormal];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMessageCell"];
    Message *message = self.messageList[indexPath.row];
    [cell configCellWithModel:message];
    return cell;
}

@end
