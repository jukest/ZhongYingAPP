//
//  ZYInformationBoxOfficeTableViewSectionHeader.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationBoxOfficeTableViewSectionHeader.h"

@interface ZYInformationBoxOfficeTableViewSectionHeader ()
@property (nonatomic, strong) NSMutableArray <UILabel *> *lables;
@end

@implementation ZYInformationBoxOfficeTableViewSectionHeader
- (NSMutableArray<UILabel *> *)lables {
    if (!_lables) {
        _lables = [NSMutableArray arrayWithCapacity:10];
    }
    return _lables;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *boxOfficeRankingLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(ZYInformationBoxOfficeHeaderViewCellLeftLabelLeftMarge, 0, 100, 20) text:@"票房排名" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [self addSubview:boxOfficeRankingLabel];
    
    UIButton *moreBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(self.width - 100 - 20, 0, 100, 20) image:[UIImage imageNamed:@"rigth_arrow"] target:self action:@selector(moreButtonAction:) tag:203];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [moreBtn setTitle:@"更多指标" forState:UIControlStateNormal];
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:moreBtn];
    
    UILabel *filmNameLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(ZYInformationBoxOfficeHeaderViewCellLeftLabelLeftMarge, boxOfficeRankingLabel.height + 10, ZYInformationBoxOfficeHeaderViewCellLeftLabelWidth, 20) text:@"影片" font:[UIFont systemFontOfSize:13*heightFloat] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
    filmNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:filmNameLabel];
    
    NSArray *titels = @[@"票房(万元)",@"票房占比",@"排片占比",@"上座率"];
    CGFloat width = (self.width - 2 * ZYInformationBoxOfficeHeaderViewCellLeftLabelLeftMarge - ZYInformationBoxOfficeHeaderViewCellLeftLabelWidth ) / titels.count;
    CGFloat y = filmNameLabel.y;
    CGFloat x = CGRectGetMaxX(filmNameLabel.frame);
    
    for (int i = 0; i < titels.count; i++) {
        UILabel *lable = [FanShuToolClass createLabelWithFrame:CGRectMake(i *  width + x, y, width, 20) text:titels[i] font:[UIFont systemFontOfSize:13*heightFloat] textColor:[UIColor grayColor] alignment:NSTextAlignmentCenter];
        [self addSubview:lable];
        [self.lables addObject:lable];
        
    }
    
}


- (void)moreButtonAction:(UIButton *)sender {
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(informationBoxOfficeTableViewSectionHeader:buttonDidClick:)]) {
            [self.delegate informationBoxOfficeTableViewSectionHeader:self buttonDidClick:sender];
        }
    }
}


@end
