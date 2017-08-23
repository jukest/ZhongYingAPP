//
//  CommentTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIViewController+Commen.h"

@implementation CommentTableViewCell

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
        self.headImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(10, 15, 50, 50) color:[UIColor grayColor]];
        self.headImg.layer.cornerRadius = 25.0f;
        self.headImg.clipsToBounds = YES;
        [self.contentView addSubview:self.headImg];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(70, 15, 150, 15) text:@"139****0000" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.nameLb];
        
        self.timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(70, 40, 150, 15) text:@"13分钟前" font:[UIFont systemFontOfSize:15] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLb];
        
        self.contentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(70, 65, ScreenWidth -70 -20, 40) text:@"片子不错" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.contentLb.numberOfLines = 0;
        [self.contentView addSubview:self.contentLb];
    }
    return self;
}

- (void)configCellWithModel:(InfoComment *)comment
{
    [self.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,comment.avatar]] placeholderImage:[UIImage imageNamed:@"user_img"]];
    self.nameLb.text = comment.nickname;
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval = currentInterval - [comment.created_time doubleValue];
    self.timeLb.text = [UIViewController getTimeStrWithInterval:interval];
    
    CGSize commentSize = [FanShuToolClass createString:comment.content font:[UIFont systemFontOfSize:15] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -70 -20, ScreenHeight)];
    self.contentLb.frame = CGRectMake(70, 65, ScreenWidth -70 -20, commentSize.height);
    self.contentLb.attributedText = [FanShuToolClass getAttributeStringWithContent:comment.content withLineSpaceing:3];
}

@end
