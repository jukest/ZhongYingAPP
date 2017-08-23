//
//  MyBillViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/21.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyBillViewController.h"
#import "MyBillCell.h"
#import "BillDetailsViewCtl.h"
#import "Bill.h"

@interface MyBillViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isEditing;
    MBProgressHUD *_HUD;
    UIButton *_rightBtn;
    MBProgressHUD *_deleteHUD;
    UIView *_editView;
    UIButton *_allBtn; //!<<全选按钮
    UIButton *_deleteBtn; //!<<删除按钮
}
@property(nonatomic,strong) NSMutableArray *myBills;
@property(nonatomic,strong) NSMutableArray *deleteIndexPaths;
@property(nonatomic,strong) NSMutableArray *deleteBills;
@end

@implementation MyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"账单";
    _rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:@"编辑" titleColor:[UIColor whiteColor] target:self action:@selector(MyBillClick:) tag:100];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    _isEditing = NO;
    // Do any additional setup after loading the view.
    [self loadMyBill];
    
    [self setupEditView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Handles
- (void)loadMyBill
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMyBillURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getMybill>>>>>>>>>>>>%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Bill *bill = [[Bill alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error = %@",error);
                }
                [self.myBills addObject:bill];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            [self showHudMessage:@"您还没有账单~"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self.myBillTableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [_HUD hide:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

- (void)deleteMyBills
{
    if (!_deleteHUD) {
        _deleteHUD = [FanShuToolClass createMBProgressHUDWithText:@"删除中..." target:self];
        [self.view addSubview:_deleteHUD];
    }else{
        _deleteHUD.labelText = @"删除中...";
        _deleteHUD.mode = MBProgressHUDModeIndeterminate;
        [_deleteHUD show:YES];
    }
    NSMutableArray *bill_ids = [NSMutableArray array];
    for (Bill *bill in self.deleteBills) {
        [bill_ids addObject:[NSString stringWithFormat:@"%zd",bill.id]];
    }
    NSString *bill_id = [bill_ids componentsJoinedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserDeleteBillURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"bill_id"] = bill_id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"deleteBillURL >>>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            [self.myBills removeObjectsInArray:self.deleteBills];
            
            [self.myBillTableView beginUpdates];
            [self.myBillTableView deleteRowsAtIndexPaths:self.deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.myBillTableView endUpdates];
            
            self.myBillTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64);
            [self.deleteBills removeAllObjects];
            [self.deleteIndexPaths removeAllObjects];
            self.myBillTableView.editing = NO;
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
            [_deleteHUD hide:YES];
            [self showHudMessage:dataBack[@"message"]];
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

#pragma mark - View Handles
- (void)MyBillClick:(UIButton *)btn{
    if (btn.tag == 100) {
        NSLog(@"编辑功能未实现");
        [self.deleteBills removeAllObjects];
        [self.deleteIndexPaths removeAllObjects];
        _isEditing = !_isEditing;
        self.myBillTableView.editing = !self.myBillTableView.editing;
        _allBtn.selected = NO;
        [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.enabled = NO;
        if (_isEditing) {
            _editView.hidden  = NO;
            self.myBillTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64 -45);
        }else{
            _editView.hidden = YES;
            self.myBillTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64);
        }
    }
}

- (void)gotoMyBillEvents:(UIButton *)btn
{
    if (btn.tag == 333) { // 全选
        [self.deleteBills removeAllObjects];
        [self.deleteIndexPaths removeAllObjects];
        if (!btn.selected) {
            btn.selected = YES;
            for (int i = 0; i < self.myBills.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.deleteIndexPaths addObject:indexPath];
                [self.myBillTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            }
            [self.deleteBills addObjectsFromArray:self.myBills];
            [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteBills.count] forState:UIControlStateNormal];
            _deleteBtn.enabled = YES;
        }else{
            btn.selected = NO;
            [self.deleteBills removeAllObjects];
            for (int i = 0; i < self.myBills.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.deleteIndexPaths removeObject:indexPath];
                [self.myBillTableView deselectRowAtIndexPath:indexPath animated:NO];
                //            cell.selected = NO;
            }
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }
    }else{ //删除
        [self deleteMyBills];
    }
}

#pragma mark - 懒加载
- (UITableView *)myBillTableView
{
    if (_myBillTableView == nil) {
        _myBillTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_myBillTableView registerClass:[MyBillCell class] forCellReuseIdentifier:@"MyBillCell"];
        _myBillTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_myBillTableView];
    }
    return _myBillTableView;
}

- (NSMutableArray *)myBills
{
    if (_myBills == nil) {
        _myBills = [NSMutableArray array];
    }
    return _myBills;
}

- (NSMutableArray *)deleteBills
{
    if (_deleteBills == nil) {
        _deleteBills = [NSMutableArray array];
    }
    return _deleteBills;
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
    return 55;
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
    Bill *bill = self.myBills[indexPath.row];
    if (tableView.isEditing) {
        [self.deleteBills addObject:bill];
        [self.deleteIndexPaths addObject:indexPath];
        [_deleteBtn setTitleColor:Color(245, 63, 91, 1.0) forState:UIControlStateNormal];
        [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteBills.count] forState:UIControlStateNormal];
        _deleteBtn.enabled = YES;
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BillDetailsViewCtl *billDetails = [[BillDetailsViewCtl alloc] init];
        billDetails.bill = bill;
        [billDetails setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:billDetails animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bill *bill = self.myBills[indexPath.row];
    if (tableView.isEditing) {
        [self.deleteBills removeObject:bill];
        [self.deleteIndexPaths removeObject:indexPath];
        if (self.deleteBills.count == 0) {
            [_deleteBtn setTitleColor:Color(189, 189, 189, 1.0) forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            _deleteBtn.enabled = NO;
        }else{
            [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.deleteBills.count] forState:UIControlStateNormal];
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
    return self.myBills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBillCell"];
    Bill *bill = self.myBills[indexPath.row];
    [cell configCellWithModel:bill];
    return cell;
}


@end
