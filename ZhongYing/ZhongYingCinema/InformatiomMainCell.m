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
#import "LHTabView.h"

@interface InformatiomMainCell ()
@property (nonatomic, strong) LHTabView *tabView;
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
//    mainView.viewController = self.VC;
//    [self.itemBaseViews addObject:mainView];
    
    ZYInformationBoxOfficeView *boxOfficeView = [[ZYInformationBoxOfficeView alloc] init];
//    weiboView.viewController = self.VC;
//    [self.itemBaseViews addObject:weiboView];
    
    _tabView = [[LHTabView alloc]initWithItemsName:@[@"新闻",@"票房"] childrenView:@[newsView,boxOfficeView] withTableView:YES withHasNavigationBar:NO];// [[LHTabView alloc]initWithItemsName:@[@"新闻",@"票房"] childrenView:@[newsView,boxOfficeView] withTableView:YES ];
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
