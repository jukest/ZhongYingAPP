//
//  ViewPackagesView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ViewPackagesView.h"
#import "PackageTableViewCell.h"

@interface ViewPackagesView ()<UITableViewDelegate,UITableViewDataSource,PackageTableViewCellDelegate>

@property(nonatomic,strong) NSMutableArray *goodsList;

@end
@implementation ViewPackagesView

- (instancetype)initWithFrame:(CGRect)frame packages:(NSArray *)goodsList
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *headerView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 47) backgroundColor:Color(245, 245, 245, 1.0)];
        
        UILabel *lb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 20, 200, 20) text:@"观影套餐" font:[UIFont systemFontOfSize:15] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        [headerView addSubview:lb];
        [self.goodsList addObjectsFromArray:goodsList];
        self.packageTableview.tableHeaderView = headerView;
    }
    return self;
}

#pragma mark - 懒加载
- (UITableView *)packageTableview
{
    if (_packageTableview == nil) {
        _packageTableview = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, self.goodsList.count * 66 +47) style:UITableViewStyleGrouped target:self];
        [_packageTableview registerClass:[PackageTableViewCell class] forCellReuseIdentifier:@"PackageTableViewCell"];
        _packageTableview.bounces = NO;
        [self addSubview:_packageTableview];
    }
    return _packageTableview;
}

- (NSMutableArray *)goodsList
{
    if (_goodsList == nil) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
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
    if ([self.delegate respondsToSelector:@selector(selectBtnDidClickedIndexpath:)]) {
        [self.delegate selectBtnDidClickedIndexpath:indexPath];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageTableViewCell"];
    Goods *goods = self.goodsList[indexPath.row];
    [cell configCellWithModel:goods];
    cell.amountView.hidden = YES;
    cell.delegate = self;
    return cell;
}

- (void)gotoBuyPackageEvent
{
  
}

@end
