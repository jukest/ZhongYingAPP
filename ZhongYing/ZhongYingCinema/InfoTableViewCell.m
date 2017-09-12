//
//  InfoTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InfoTableViewCell

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
        
        
        
        self.headImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(10*widthFloat, 10*heightFloat, InformationViewControllerTableViewCellImgWidth * widthFloat, (InformationViewControllerTableViewCellHeight - 20)*heightFloat) color:[UIColor grayColor]];
        self.headImg.layer.cornerRadius = 10;
        self.headImg.layer.masksToBounds = YES;
//        self.headImg.center = CGPointMake(70 * widthFloat, 57.5 * heightFloat);
        [self.contentView addSubview:self.headImg];
        
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.headImg.frame) + 10*widthFloat, 10 * heightFloat, ScreenWidth - InformationViewControllerTableViewCellImgWidth * widthFloat, 0) text:@"" font:[UIFont systemFontOfSize:16 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.titleLb.numberOfLines = 0;
        [self.contentView addSubview:self.titleLb];
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.headImg.frame) + 10*widthFloat, 75 * heightFloat, InformationViewControllerTableViewCellImgWidth * widthFloat, 20 * heightFloat) text:@"" font:[UIFont systemFontOfSize:14 * widthFloat] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.dateLb];
        
        self.pageviewsBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -120 * widthFloat, 75 * heightFloat, 50 * widthFloat, 20 * heightFloat) title:@"" titleColor:[UIColor grayColor] target:nil action:nil tag:100];
        self.pageviewsBtn.titleLabel.font = [UIFont systemFontOfSize:14 * widthFloat];
        [self.pageviewsBtn setImage:[UIImage imageNamed:@"info_pageviews"] forState:UIControlStateNormal];
        [self.pageviewsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self.contentView addSubview:self.pageviewsBtn];
        
        self.commentsBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -70 * widthFloat, 75 * heightFloat, 50 * widthFloat, 20 * heightFloat) title:@"" titleColor:[UIColor grayColor] target:nil action:nil tag:101];
        self.commentsBtn.titleLabel.font = [UIFont systemFontOfSize:14 * widthFloat];
        [self.commentsBtn setImage:[UIImage imageNamed:@"info_comments"] forState:UIControlStateNormal];
        [self.commentsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self.contentView addSubview:self.commentsBtn];
        
        //加黄色的分割线
        UIView *yellowLine = [[UIView alloc]initWithFrame:CGRectMake(self.headImg.x, (InformationViewControllerTableViewCellHeight) * heightFloat - 2, InformationViewControllerTableViewCellImgWidth*widthFloat, 2)];
        yellowLine.backgroundColor = Color(252, 186, 0, 1.0);
        [self addSubview:yellowLine];
        
        //加灰色的分割线
        UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yellowLine.frame), (InformationViewControllerTableViewCellHeight) * heightFloat - 2, ScreenWidth - 20 - self.headImg.width , 2)];
        grayLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:grayLine];
        
        
        
        
        
    }
    return self;
}

- (void)configCellWithModel:(News *)news
{
//    [self.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,news.cover]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,news.cover]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    CGSize titleSize = [FanShuToolClass createString:news.title font:[UIFont systemFontOfSize:16 * widthFloat] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth - InformationViewControllerTableViewCellImgWidth * widthFloat, ScreenHeight)];
    
    self.titleLb.frame = CGRectMake(CGRectGetMaxX(self.headImg.frame) + 10*widthFloat, 10 * heightFloat, ScreenWidth -(InformationViewControllerTableViewCellImgWidth + 30) * widthFloat, titleSize.height);
    self.titleLb.attributedText = [FanShuToolClass getAttributeStringWithContent:news.title withLineSpaceing:3];

    self.dateLb.text = [news.created_time transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"];
    
    [self.pageviewsBtn setTitle:news.rate forState:UIControlStateNormal];
    [self.commentsBtn setTitle:news.comment forState:UIControlStateNormal];
}

@end
