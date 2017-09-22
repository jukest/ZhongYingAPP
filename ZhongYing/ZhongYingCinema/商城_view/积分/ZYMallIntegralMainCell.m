//
//  ZYMallIntegralMainCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMallIntegralMainCell.h"
#import "LHTabView.h"
#import "ZYMyIntegralView.h"
#import "ZYExchangeRecordsView.h"

@interface ZYMallIntegralMainCell ()

@property (nonatomic, strong) LHTabView *tabView;

@property (nonatomic, assign) BOOL isMain;

@end

@implementation ZYMallIntegralMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIsMain:(BOOL)isMain {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.isMain = isMain;
        [self setup];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.isMain = YES;
        [self setup];
        
    }
    return self;
}


- (void)setup {
    ZYMyIntegralView *myIntegralView = [[ZYMyIntegralView alloc] init];
    ZYExchangeRecordsView *exchangeRecordsView = [[ZYExchangeRecordsView alloc] init];
    
    
    _tabView = [[LHTabView alloc]initWithItemsName:@[@"我的积分",@"兑换记录"] withImages:nil childrenView:@[myIntegralView,exchangeRecordsView] withTableView:YES withHasNavigationBar:YES isMain:self.isMain];
    [self.contentView addSubview:_tabView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.tabView.firstTitle = title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tabView.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
