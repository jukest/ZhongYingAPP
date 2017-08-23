//
//  MyReviewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/6.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyReviewCell.h"

@interface MyReviewCell ()
{
    UIView *_starBackgroundView;
    UIView *_starForegroundView;
}
@end
@implementation MyReviewCell

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

        _starBackgroundView = [self buidlStarViewWithImageName:@"movie_start_black"];
        _starForegroundView = [self buidlStarViewWithImageName:@"movie_start"];
        [self.contentView addSubview:_starBackgroundView];
        [self.contentView addSubview:_starForegroundView];
        
        self.markLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +110 +6, 15, 30, 20) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(46, 161, 234, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.markLb];
        
        self.reviewDateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -12 -100, 15, 100, 15) text:@"" font:[UIFont systemFontOfSize:13] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.reviewDateLb];
        
        self.reviewLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 15 +20 +10, ScreenWidth -12 -25, 0) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.reviewLb.numberOfLines = 0;
        [self.contentView addSubview:self.reviewLb];
        
        self.movieView = [FanShuToolClass createViewWithFrame:CGRectMake(15, 15 +15 +10 +self.reviewLb.frame.size.height +14, ScreenWidth -30, 93) backgroundColor:Color(245, 245, 245, 1.0)];
        [self.contentView addSubview:self.movieView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movieViewDidClicked:)];
        [self.movieView addGestureRecognizer:tap];
        
        self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 67, 93) image:[UIImage imageNamed:@""] tag:105];
        [self.movieView addSubview:self.movieImg];
        
        self.movieNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(67 +10, 12, ScreenWidth -15 -67 -10 -15 -20, 17) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.movieView addSubview:self.movieNameLb];
        
        NSString *address = @"";
        CGSize addressSize = [address sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        self.addressLb = [FanShuToolClass createLabelWithFrame:CGRectMake(67 +10, 12 +17 +13, addressSize.width, addressSize.height) text:address font:[UIFont systemFontOfSize:15] textColor:Color(25, 25, 25, 1.0) alignment:NSTextAlignmentLeft];
        [self.movieView addSubview:self.addressLb];
        
        self.hallLb = [FanShuToolClass createLabelWithFrame:CGRectMake(67 +10 +addressSize.width +5, 12 +17 +13, 60, addressSize.height) text:@"" font:[UIFont systemFontOfSize:15] textColor:Color(25, 25, 25, 1.0) alignment:NSTextAlignmentLeft];
        [self.movieView addSubview:self.hallLb];
        
        NSString *date = @"";
        CGSize dateSize = [date sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        self.releaseDateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(67 +10, 12 +17 +13 +addressSize.height +9, dateSize.width, 13) text:date font:[UIFont systemFontOfSize:15] textColor:Color(25, 25, 25, 1.0) alignment:NSTextAlignmentLeft];
        [self.movieView addSubview:self.releaseDateLb];

    }
    return self;
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = CGRectMake(12, 15, 100 +10, 20);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < 5; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(22 * i, 0, 20, 20);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)movieViewDidClicked:(UIGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(MovieViewDidSelectedIndexPath:)]) {
        [self.delegate MovieViewDidSelectedIndexPath:self.indexPath];
    }
}

- (void)configCellWithModel:(MyFilmComment *)comment
{
    _starForegroundView.frame = CGRectMake(12, 15, 110 * ([comment.stars integerValue]) / 10, 20);
    self.markLb.text = [NSString stringWithFormat:@"%zd",[comment.stars integerValue]];
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval = currentInterval - comment.comment_time;
    self.reviewDateLb.text = [UIViewController getTimeStrWithInterval:interval];
    
    CGSize reviewSize = [FanShuToolClass createString:comment.content font:[UIFont systemFontOfSize:16] lineSpacing:2 maxSize:CGSizeMake(ScreenWidth -12 -25, ScreenHeight)];
    self.reviewLb.frame = CGRectMake(12, 15 +20 +10, ScreenWidth -12 -25, reviewSize.height);
    self.reviewLb.attributedText = [FanShuToolClass getAttributeStringWithContent:comment.content withLineSpaceing:2.0];
    self.movieView.frame = CGRectMake(15, 15 +15 +10 +self.reviewLb.frame.size.height +14, ScreenWidth -30, 93);
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,comment.cover]] placeholderImage:[UIImage imageNamed:@""]];
    self.movieNameLb.text = comment.name;
    self.addressLb.text = comment.cinema_name;
    CGSize addressSize = [comment.cinema_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.addressLb.frame = CGRectMake(67 +10, 12 +17 +13, addressSize.width, addressSize.height);
    self.hallLb.text = comment.hall_name;
    CGSize hallSize = [comment.hall_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.hallLb.frame = CGRectMake(67 +10 +addressSize.width +5, 12 +17 +13, hallSize.width, addressSize.height);

    if (comment.start_time != nil) {
        self.releaseDateLb.text = [[NSString stringWithFormat:@"%@",comment.start_time] transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd HH:mm"];
    }
    CGSize dateSize = [self.releaseDateLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.releaseDateLb.frame = CGRectMake(67 +10, 12 +17 +13 +addressSize.height +9, dateSize.width, 13);
}


@end
