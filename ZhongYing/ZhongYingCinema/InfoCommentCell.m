
//
//  InfoCommentCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "InfoCommentCell.h"

@implementation InfoCommentCell

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
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 16, ScreenWidth -12 -18 -50, 20) text:@"《战狼2》杀青，吴京：受伤没事有付出才有回报。" font:[UIFont systemFontOfSize:18] textColor:Color(30, 30, 30, 1.0) alignment:NSTextAlignmentLeft];
        self.titleLb.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.titleLb];
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -18 -50, 16, 50, 15) text:@"11-03" font:[UIFont systemFontOfSize:14] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.dateLb];
        
        self.commentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 16 +20 +13, ScreenWidth -12 -18, 0) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentLeft];
        self.commentLb.numberOfLines = 0;
        [self.contentView addSubview:self.commentLb];
    }
    return self;
}

- (void)configCellWithModel:(NewsComment *)comment
{
    CGSize commentSize = [FanShuToolClass createString:comment.content font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -12 -18, ScreenHeight)];
    self.commentLb.frame = CGRectMake(12, 16 +20 +13, ScreenWidth -12 -18, commentSize.height);
    self.commentLb.attributedText = [FanShuToolClass getAttributeStringWithContent:comment.content withLineSpaceing:3];
    
    self.titleLb.text = comment.title;
    self.dateLb.text = [comment.created_time transforTomyyyyMMddWithFormatter:@"MM-dd"];
}

@end
