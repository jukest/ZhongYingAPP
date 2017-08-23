//
//  MovieReviewTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieReviewTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MovieReviewTableViewCell

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
        self.headImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 10, 45, 45) color:[UIColor grayColor]];
        self.headImg.layer.cornerRadius = 22.5;
        self.headImg.clipsToBounds = YES;
        self.headImg.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:self.headImg];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +10 +45, 12, 200, 15) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.nameLb];
        
        self.markLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -100 -15, 12, 100, 20) text:@"" font:[UIFont systemFontOfSize:18] textColor:Color(253, 164, 40, 1.0) alignment:NSTextAlignmentRight];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.markLb.text];
        NSRange range = [self.markLb.text rangeOfString:@"分"];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
        self.markLb.attributedText = str;
        [self.contentView addSubview:self.markLb];
        
        self.contentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +10 +45, 40, ScreenWidth -70, 100) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.contentLb.numberOfLines = 0;
        [self.contentView addSubview:self.contentLb];
        
        self.createTimeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -100 -15, 0, 100, 10) text:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor grayColor] alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.createTimeLb];
    }
    return self;
}

- (void)configCellWithComment:(MovieComment *)comment
{
    CGSize commentSize = [FanShuToolClass createString:comment.content font:[UIFont systemFontOfSize:16] lineSpacing:5 maxSize:CGSizeMake(ScreenWidth -100, ScreenHeight)];
    self.contentLb.frame = CGRectMake(12 +10 +45, 40, ScreenWidth -100, commentSize.height);
    self.contentLb.text = comment.content;
    // 设置文字行距
    NSString *titleLabelText = self.contentLb.text;
    self.contentLb.attributedText = [FanShuToolClass getAttributeStringWithContent:titleLabelText withLineSpaceing:5];
    
    self.createTimeLb.frame = CGRectMake(ScreenWidth -100 -15, 40 +commentSize.height +10, 100, 10);
    
    self.nameLb.text = comment.nickname;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,comment.avatar]] placeholderImage:[UIImage imageNamed:@"user_img"]];
    self.markLb.text = [NSString stringWithFormat:@"%@分",comment.stars];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.markLb.text];
    NSRange range = [self.markLb.text rangeOfString:@"分"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
    self.markLb.attributedText = str;
    
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval = currentInterval - [comment.created_time doubleValue];
    self.createTimeLb.text = [UIViewController getTimeStrWithInterval:interval];
}

@end
