


//
//  MovieCommentCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieCommentCell.h"

@interface MovieCommentCell ()
{
    UIView *_starBackgroundView;
    UIView *_starForegroundView;
}
@end
@implementation MovieCommentCell

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
        self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 12, 66, 91) image:[UIImage imageNamed:@""] tag:100];
        [self.contentView addSubview:self.movieImg];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +66 +12, 16, ScreenWidth -(12+66+12) -18-50, 18) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(30, 30, 30, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.nameLb];
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -18 -50, 16, 50, 15) text:@"" font:[UIFont systemFontOfSize:14] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.dateLb];
        
        _starBackgroundView = [self buidlStarViewWithImageName:@"movie_start_black"];
        _starForegroundView = [self buidlStarViewWithImageName:@"movie_start"];
        [self.contentView addSubview:_starBackgroundView];
        [self.contentView addSubview:_starForegroundView];
        
        self.markLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +66 +12 +69 +6, 16 +18 +9, 30, 13) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(81, 171, 236, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.markLb];
        
        self.commentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +66 +12, 16 +18 +9 +13 +9, ScreenWidth -12 -66 -12 -18, 40) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentLeft];
        self.commentLb.numberOfLines = 0;
        self.commentLb.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.commentLb];
        self.commentLb.attributedText = [FanShuToolClass getAttributeStringWithContent:self.commentLb.text withLineSpaceing:3];
    }
    return self;
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = CGRectMake(12 +66 +12, 16 +18 +9, 69, 13);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < 5; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * 14, 0, 13, 13);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)configCellWithModel:(FilmComment *)comment
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,comment.cover]] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLb.text = comment.name;
    self.dateLb.text = [[NSString stringWithFormat:@"%zd",comment.created_time] transforTomyyyyMMddWithFormatter:@"MM-dd"];
    _starForegroundView.frame = CGRectMake(12 +66 +12, 16 +18 +9, 69 * (comment.stars) / 10, 13);
    self.markLb.text = [NSString stringWithFormat:@"%zd",comment.stars];
    self.commentLb.text = comment.content;
}

- (void)layoutSubviews {
    self.commentLb.frame = CGRectMake(self.commentLb.x, self.commentLb.y, self.commentLb.width, self.height - CGRectGetMaxY(self.markLb.frame));

}

@end
