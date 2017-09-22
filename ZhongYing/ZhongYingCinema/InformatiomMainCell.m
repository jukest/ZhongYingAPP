//
//  InformatiomMainCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "InformatiomMainCell.h"
#import "ZYInformationNewsView.h"
#import "ZYInformationBoxOfficeView.h"
#import "WXTabView.h"

@interface InformatiomMainCell ()
@property (nonatomic, strong) WXTabView *tabView;
@end

@implementation InformatiomMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self setup];
        
    }
    return self;
}


- (void)setup {
    ZYInformationNewsView *newsView = [[ZYInformationNewsView alloc] init];

    
    ZYInformationBoxOfficeView *boxOfficeView = [[ZYInformationBoxOfficeView alloc] init];
    
    _tabView = [[WXTabView alloc]initWithItemsName:@[@"资讯",@"票房"] withImages:@[@"info_news",@"info_boxoffice"] childrenView:@[newsView,boxOfficeView] withTableView:YES withHasNavigationBar:NO];
    [self.contentView addSubview:_tabView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
