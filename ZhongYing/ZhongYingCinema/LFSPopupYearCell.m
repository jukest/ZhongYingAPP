//
//  LFSPopupYearCell.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "LFSPopupYearCell.h"

@implementation LFSPopupYearCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth-50, 1) backgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:lineView];
        
        self.yearLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 0, ScreenWidth-100, 50) text:@"" font:[UIFont systemFontOfSize:17] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.yearLb];
    }
    return self;
}

@end
