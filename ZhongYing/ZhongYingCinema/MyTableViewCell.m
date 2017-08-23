//
//  MyTableViewCell.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/16.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(20, 12.5, 25, 25) color:[UIColor clearColor]];
        [self.contentView addSubview:self.leftImg];
        
        self.leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(60, 10, ScreenWidth-100, 30) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.leftLb];
        
        self.rightImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-26, 21, 8, 15) image:[UIImage imageNamed:@"cinema_back"] tag:100];
        self.rightImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.rightImg];
    }
    return self;
}

@end
