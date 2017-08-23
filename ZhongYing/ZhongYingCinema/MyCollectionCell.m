//
//  MyCollectionCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 10, ScreenWidth, 119) backgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:view];
        
        self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 13, 67, 93) image:[UIImage imageNamed:@""] tag:100];
        [view addSubview:self.movieImg];
        
        NSString *name = @"";
        CGSize size =[name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +67 +9, 23, size.width, 18) text:name font:[UIFont systemFontOfSize:16 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [view addSubview:self.nameLb];
        
        self.is3DImg = [FanShuToolClass createButtonWithFrame:CGRectMake(12 +67 +9 +size.width +5, self.nameLb.center.y -8, 20, 15) title:@"3D" titleColor:[UIColor whiteColor] target:nil action:nil tag:2000];
        self.is3DImg.center = CGPointMake(96 + size.width +5 +10, self.nameLb.center.y);
        self.is3DImg.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.is3DImg setBackgroundImage:[UIImage imageNamed:@"movie_type"] forState:UIControlStateNormal];
        [view addSubview:self.is3DImg];
        
        self.typesLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +67 +9, 23 +18 +11, 200, 16) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentLeft];
        [view addSubview:self.typesLb];
        
        self.detailsLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +67 +9, 23 +18 +11 +16 +7, 200, 16) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(70, 70, 70, 1.0) alignment:NSTextAlignmentLeft];
        [view addSubview:self.detailsLb];
    }
    return self;
}

- (void)configCellWithModel:(Collection *)collection
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,collection.cover]] placeholderImage:[UIImage imageNamed:@""]];
    CGSize size =[collection.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 * widthFloat]}];
    self.nameLb.frame = CGRectMake(12 +67 +9, 23, size.width, 18);
    self.nameLb.text = collection.name;
    if (collection.tags.count != 0) {
        CGSize tagSize = [collection.tags[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        self.is3DImg.frame = CGRectMake(12 +67 +9 +size.width +5, self.nameLb.center.y -8, ceil(tagSize.width +5), 15);
        self.is3DImg.center = CGPointMake(ceil(12 +67 +9 +size.width +5 +(tagSize.width +5) / 2), ceil(self.nameLb.center.y));
        [self.is3DImg setTitle:collection.tags[0] forState:UIControlStateNormal];
    }else{
        self.is3DImg.hidden = YES;
    }
    if (collection.label.count != 0) {
        NSString *type = [collection.label componentsJoinedByString:@" "];
        self.typesLb.text = type;
    }else{
        self.typesLb.hidden = YES;
    }
    self.detailsLb.text = [NSString stringWithFormat:@"%@/%@分钟",collection.source,collection.length];
}

@end
