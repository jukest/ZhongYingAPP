//
//  AboutUsCell.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/30.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "AboutUsCell.h"

@implementation AboutUsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.aboutUsLeftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 10, ScreenWidth/2 - 10, 30) text:@"" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.aboutUsLeftLb];
        
        self.aboutUsRightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 10, ScreenWidth-10, 30) text:@"" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.aboutUsRightLb];
    }
    return self;
}

@end
