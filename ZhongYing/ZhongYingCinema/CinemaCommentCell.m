


//
//  CinemaCommentCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaCommentCell.h"

@interface CinemaCommentCell ()
{
    UIView *_backgroundView;
}
@end
@implementation CinemaCommentCell

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
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 16, 100, 17) text:@"" font:[UIFont systemFontOfSize:18] textColor:Color(30, 30, 30, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.nameLb];
        
        _backgroundView = [FanShuToolClass createViewWithFrame:CGRectMake(12 +self.nameLb.frame.size.width +8, 16, 80, 15) backgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_backgroundView];
        for (int i = 0; i < 5; i ++) {
            UIImageView *imgage = [FanShuToolClass createImageViewWithFrame:CGRectMake(i * 16, 0, 15, 15) image:[UIImage imageNamed:@"movie_not_collect"] tag:50 +i];
            [_backgroundView addSubview:imgage];
        }
        
        self.starView = [FanShuToolClass createViewWithFrame:CGRectMake(12 +self.nameLb.frame.size.width +8, 16, 80, 15) backgroundColor:[UIColor whiteColor]];
        self.starView.clipsToBounds = YES;
        [self.contentView addSubview:self.starView];
        
        for (int i = 0; i < 5; i ++) {
            UIImageView *imgage = [FanShuToolClass createImageViewWithFrame:CGRectMake(i * 16, 0, 15, 15) image:[UIImage imageNamed:@"movie_collect"] tag:100 +i];
            [self.starView addSubview:imgage];
        }
        
        self.markLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +self.nameLb.frame.size.width +8 +self.starView.frame.size.width +5, 16, 30, 15) text:@"10" font:[UIFont systemFontOfSize:16] textColor:Color(81, 171, 236, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.markLb];
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -18 -50, 16, 50, 15) text:@"11-03" font:[UIFont systemFontOfSize:14] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.dateLb];
        
        self.commentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 48, ScreenWidth -12 -45, 0) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentLeft];
        self.commentLb.numberOfLines = 0;
        [self.contentView addSubview:self.commentLb];
    }
    return self;
}

- (void)configCellWithModel:(CinemaComment *)cinemaComment
{
    NSString *name = cinemaComment.title;
//    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.nameLb.frame = CGRectMake(12, 16, ScreenWidth - self.dateLb.width - 15 - 12 - 10, 17);
    self.nameLb.text = name;
    _backgroundView.frame = CGRectMake(12, CGRectGetMaxY(self.nameLb.frame)+5, 80, 15);
    self.starView.frame = CGRectMake(12, CGRectGetMaxY(self.nameLb.frame)+5, 80 * ([cinemaComment.stars floatValue] / 10.0) , 15);
    self.markLb.text = cinemaComment.stars;
    self.markLb.frame = CGRectMake(CGRectGetMaxX(_backgroundView.frame) +5, CGRectGetMaxY(self.nameLb.frame)+5, 30, 15);
    CGSize commentSize = [FanShuToolClass createString:cinemaComment.content font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -12 -45, ScreenHeight)];
    self.commentLb.frame = CGRectMake(12, CGRectGetMaxY(_backgroundView.frame)+5, ScreenWidth -12 -45, commentSize.height);
    self.commentLb.attributedText = [FanShuToolClass getAttributeStringWithContent:cinemaComment.content withLineSpaceing:3];
    self.dateLb.text = [cinemaComment.created_time transforTomyyyyMMddWithFormatter:@"MM-dd"];
    
}

@end
