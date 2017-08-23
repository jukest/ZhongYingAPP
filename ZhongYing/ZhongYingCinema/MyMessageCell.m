//
//  MyMessageCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyMessageCell.h"

@implementation MyMessageCell

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
        
        self.messageImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(17, 16, 48, 48) image:[UIImage imageNamed:[NSString stringWithFormat:@"message_%zd",arc4random() % 2 +1]] tag:100];
        self.messageImg.backgroundColor = [UIColor grayColor];
        self.messageImg.layer.cornerRadius = 24;
        self.messageImg.clipsToBounds = YES;
        [self.contentView addSubview:self.messageImg];
        
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(17 +48 +16, 16, ScreenWidth -(17 +48 +16) -60, 20) text:@"活动广播" font:[UIFont systemFontOfSize:18 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.titleLb.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.titleLb];
        
        self.receiveTimeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -60, 16, 40, 13) text:@"10-25" font:[UIFont systemFontOfSize:13 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.receiveTimeLb];
        
        self.contentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(17 +48 +16, 16 +20 +10, ScreenWidth -17 -48 -16 -20, 15) text:@"太棒了，你已达到“哼哈”成就，赶紧去看看!这个好" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentLeft];
        self.contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.contentLb];
    }
    return self;
}

- (void)configCellWithModel:(Message *)message
{
    self.titleLb.text = message.title;
    self.contentLb.text = message.content;
    self.receiveTimeLb.text = message.created_time;
    self.messageImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"message_%zd",[message.theme integerValue] +1]];
}

@end
