//
//  ZYMemberViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMemberViewController.h"
#import "ZYZYMemberViewControllerTableViewHeaderView.h"
#import "RefundView.h"

@interface ZYMemberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) ZYZYMemberViewControllerTableViewHeaderView *header;
@end

@implementation ZYMemberViewController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"会员条款",@"会员卡充值记录",@"会员卡详情",@"使用门店"];
    }
    return _titleArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];//mall_member
    [self.view addSubview:self.tableView];
    
    self.header = [[ZYZYMemberViewControllerTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 280)];
    
    self.tableView.tableHeaderView = self.header;
    
    
    NSString *content = @"会员功能还在开发中";
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:shareAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
    

}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
        
    }
    
    if (indexPath.row == self.titleArray.count - 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"中影泰德影城龙岗店";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];

    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

@end














