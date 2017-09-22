//
//  CustomCell.m
//  SimultaneousTest
//
//  Created by Leon.Hwa on 17/4/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "CustomCell.h"
#import "LHTabView.h"

#import "MainView.h"

#import "WeiboView.h"
#import "ItemBaseView.h"
@interface CustomCell()
@property (nonatomic, strong) LHTabView *tabView;
@property (nonatomic, strong) NSMutableArray <ItemBaseView *>*itemBaseViews;
@end

@implementation CustomCell

- (NSMutableArray<ItemBaseView *> *)itemBaseViews {
    if (!_itemBaseViews) {
        _itemBaseViews = [NSMutableArray arrayWithCapacity:10];
    }
    return _itemBaseViews;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setVC:(UIViewController *)VC {
    _VC = VC;
    
    for (int i = 0; i < self.itemBaseViews.count; i++) {
        ItemBaseView *view = self.itemBaseViews[i];
        view.viewController = VC;
    }
    
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        MainView *mainView = [[MainView alloc] init];
        mainView.viewController = self.VC;
        [self.itemBaseViews addObject:mainView];

        WeiboView *weiboView = [[WeiboView alloc] init];
        weiboView.viewController = self.VC;
        [self.itemBaseViews addObject:weiboView];

        _tabView = [[LHTabView alloc]initWithItemsName:@[@"正在热映",@"即将上映"] withImages:nil childrenView:@[mainView,weiboView] withTableView:NO withHasNavigationBar:YES isMain:YES]; // [[LHTabView alloc]initWithItemsName:@[@"正在热映",@"即将上映"] childrenView:@[mainView,weiboView] withTableView:NO];
        [self.contentView addSubview:_tabView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tabView.frame = self.bounds;
}

- (void)setDatas:(NSMutableArray *)datas {
    _datas = datas;
    
    
}


@end
