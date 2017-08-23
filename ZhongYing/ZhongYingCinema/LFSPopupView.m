//
//  LFSPopupView.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "LFSPopupView.h"
#import "LFSPopupYearCell.h"
#import "LFSPopupSexCell.h"

@implementation LFSPopupView

- (void)createTableViewWithArr:(NSArray *)popupArr withTitle:(NSString *)title withBackColor:(UIColor *)color withType:(LFSPopupStatus)type withLFSBlock:(LFSPopupBlock)LFSBlock{
    _popupArr = [[NSArray alloc] initWithArray:popupArr];
    _popupTitle = title;
    self.backgroundColor = color;
    _popupStatus = type;
    _LFSBlock = LFSBlock;
    // 点击整个视图去掉弹窗
    [self addTarget:self action:@selector(closeAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 50*(_popupArr.count+1)) style:UITableViewStylePlain];
    self.tableView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 4.0f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (type == LFSPopup_year) {
        [self.tableView registerClass:[LFSPopupYearCell class] forCellReuseIdentifier:@"LFSPopupYearCell"];
    }else if (type == LFSPopup_sex) {
        [self.tableView registerClass:[LFSPopupSexCell class] forCellReuseIdentifier:@"LFSPopupSexCell"];
    }
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _popupArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50) backgroundColor:[UIColor whiteColor]];
    
    UILabel *headLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 50) text:_popupTitle font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [headView addSubview:headLb];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_popupStatus == LFSPopup_year) {
        LFSPopupYearCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFSPopupYearCell"];
        cell.yearLb.text = _popupArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        NSArray *sexImgArr = @[@"Login_sex_man",@"Login_sex_woman"];
        LFSPopupSexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFSPopupSexCell"];
        cell.sexLb.text = _popupArr[indexPath.row];
        cell.sexImg.image = [UIImage imageNamed:sexImgArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_LFSBlock) {
        _LFSBlock((int)indexPath.row);
    }
    [self closeAnimation];
}

#pragma mark - closeAnimation
- (void)closeAnimation{
    [UIView transitionWithView:self.superview duration:0.25f options:UIViewAnimationOptionTransitionNone animations:^{
        self.tableView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
