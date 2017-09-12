//
//  ComplaintViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ComplaintViewCtl.h"
#import "ComplaintCell.h"
#import "Complaint.h"
@interface ComplaintViewCtl ()
{
    NSArray *_arr;
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong) NSMutableArray *complaints;
@property(nonatomic,assign) NSInteger currentPage;

@end

@implementation ComplaintViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"反馈统计";
    _currentPage = 0;
    
    [self loadUserMyComplaint];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods
- (void)loadUserMyComplaint
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMyComplaintURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"page"] = @(_currentPage);
    parameters[@"size"] = @(10);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getMyComplaint>>>>>>>>%@",dataBack);
        if (self.currentPage == 0) {
            [self.complaints removeAllObjects];
            [self.complaintTableView.mj_header endRefreshing];
        }else {
            [self.complaintTableView.mj_footer endRefreshing];
        }
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *content = dataBack[@"content"];
            for (NSDictionary *dict in content[@"list"]) {
                NSError *error;
                Complaint *complaint = [[Complaint alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error >>>>>>>>> %@",error);
                }
                [self.complaints addObject:complaint];
            }
        }else if([dataBack[@"code"] integerValue] == 46005){
            if (self.currentPage == 0) {
                [self showHudMessage:@"你还没有反馈信息!"];
                [self.complaintTableView reloadData];
            }else{
                [self showHudMessage:@"没有更多了!"];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self.complaintTableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        if (self.currentPage == 0) {
            [self.complaintTableView.mj_header endRefreshing];
        }else {
            [self.complaintTableView.mj_footer endRefreshing];
        }
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)addRefreshView
{
    __weak ComplaintViewCtl *complaint = self;
    self.complaintTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        complaint.currentPage = 0;
        [complaint loadUserMyComplaint];
    }];
    
    self.complaintTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        complaint.currentPage ++;
        [complaint loadUserMyComplaint];
    }];
    //[self hideRefreshViewsubViews:self.complaintTableView];
}

#pragma mark - 懒加载
- (UITableView *)complaintTableView
{
    if (_complaintTableView == nil) {
        _complaintTableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped target:self];
        [_complaintTableView registerClass:[ComplaintCell class] forCellReuseIdentifier:@"ComplaintCell"];
        [self addRefreshView];
        [self.view addSubview:_complaintTableView];
    }
    return _complaintTableView;
}

- (NSMutableArray *)complaints
{
    if (_complaints == nil) {
        _complaints = [NSMutableArray array];
    }
    return _complaints;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Complaint *dict = self.complaints[indexPath.row];
    NSString *complaint = dict.complaint;
    NSString *reply = dict.reply;
    CGSize complaintSize = [FanShuToolClass createString:complaint font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -12 -42 -8 -18, ScreenHeight)];
    CGSize replySize = [FanShuToolClass createString:reply font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -62 -15 -20, ScreenHeight)];
    CGFloat replyHeight;
    if ([reply isEqualToString:@""]) {
        replyHeight = -8;
    }else{
        replyHeight = 88 +replySize.height;
    }
    return 90 +replyHeight +complaintSize.height -17;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.complaints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComplaintCell"];
    Complaint *complaint = self.complaints[indexPath.row];
    [cell configCellWithModel:complaint];
    return cell;
}

@end
