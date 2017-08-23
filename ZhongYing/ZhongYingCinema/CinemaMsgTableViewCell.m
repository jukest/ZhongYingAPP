//
//  CinemaMsgTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaMsgTableViewCell.h"

@implementation CinemaMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 0, 15, 20) color:[UIColor clearColor]];
        self.iconImg.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImg.center = CGPointMake(12 + 7.5, 35);
        [self.contentView addSubview:self.iconImg];
        NSString *message = @"罗湖区东门中路东门步行街UCITY商业中心5-6楼(茂业百货旁)";
        CGSize messageSize = [FanShuToolClass createString:message font:[UIFont systemFontOfSize:16] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth -90, ScreenHeight)];
        self.messageLb = [FanShuToolClass createLabelWithFrame:CGRectMake(50, 0, messageSize.width, messageSize.height) text:message font:[UIFont systemFontOfSize:18] textColor:Color(51, 51, 51, 1.0) alignment:NSTextAlignmentLeft];
        self.messageLb.numberOfLines = 0;
        self.messageLb.center = CGPointMake(40 +messageSize.width / 2, 35);
        [self.contentView addSubview:self.messageLb];
        
        self.gotoImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth -30, 0, 12, 16) color:[UIColor clearColor]];
        self.gotoImg.image = [UIImage imageNamed:@"cinema_back"];
        self.gotoImg.contentMode = UIViewContentModeScaleAspectFit;
        self.gotoImg.center = CGPointMake(ScreenWidth -30 +6, 35);
        [self.contentView addSubview:self.gotoImg];
    }
    return self;
}

@end
