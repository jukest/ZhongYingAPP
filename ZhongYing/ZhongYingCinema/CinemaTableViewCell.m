//
//  CinemaTableViewCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/24.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CinemaTableViewCell ()
{
    UIView *_starBackgroundView;
    UIView *_starForegroundView;
    CGSize _nameSize;
    UIView *_typeView;
    UIView *_firstLine;
    UIView *_secLine;
}
@end
@implementation CinemaTableViewCell

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
       
        self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(15 * widthFloat, 10 * heightFloat, 66 * widthFloat, 92 * heightFloat) color:[UIColor grayColor]];
        //self.movieImg.center = CGPointMake(48, 57);
        self.movieImg.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:self.movieImg];
        
        self.playBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 25 * widthFloat, 25 * widthFloat) image:[UIImage imageNamed:@"movie_play"] target:self action:@selector(gotoCinemaEvents:) tag:CinemaTableViewCellPlayEvents];
        self.playBtn.center = CGPointMake(33 * widthFloat, 46 * heightFloat);
        [self.movieImg addSubview:self.playBtn];
        
        NSString *name = @"鲁滨逊漂流记";
        CGSize size =[name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 * widthFloat]}];
        _nameSize = size;
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(96 * widthFloat, 15 * heightFloat, size.width, size.height) text:name font:[UIFont systemFontOfSize:18 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.nameLb.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.nameLb];
        
        self.is3DImg = [FanShuToolClass createButtonWithFrame:CGRectMake(96 * widthFloat + size.width +5, self.nameLb.center.y -8, 18, 14) title:@"3D" titleColor:[UIColor whiteColor] target:nil action:nil tag:2000];
        self.is3DImg.center = CGPointMake(96 * widthFloat + size.width +5 +9, self.nameLb.center.y);
        self.is3DImg.titleLabel.font = [UIFont systemFontOfSize:10 * widthFloat];
        [self.is3DImg setBackgroundImage:[UIImage imageNamed:@"movie_type"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.is3DImg];
        
        self.hotImg = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -60 * widthFloat, 0, 30 * widthFloat, 40 * heightFloat) title:@"今日\n最热" titleColor:[UIColor whiteColor] target:nil action:nil tag:3000];
        self.hotImg.titleLabel.font = [UIFont systemFontOfSize:12 * widthFloat];
        self.hotImg.titleLabel.numberOfLines = 0;
        [self.hotImg setBackgroundImage:[UIImage imageNamed:@"movie_hot"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.hotImg];
        
        _starBackgroundView = [self buidlStarViewWithImageName:@"movie_start_black"];
        _starForegroundView = [self buidlStarViewWithImageName:@"movie_start"];
        [self.contentView addSubview:_starBackgroundView];
        [self.contentView addSubview:_starForegroundView];
        
        self.markLb = [FanShuToolClass createLabelWithFrame:CGRectMake(96 * widthFloat +87 +5, size.height +15 +8, 30, 15) text:@"8.9" font:[UIFont systemFontOfSize:14 * widthFloat] textColor:Color(94, 173, 235, 1.0) alignment:NSTextAlignmentLeft];
        self.markLb.center = CGPointMake(ceil(96 * widthFloat +87 +5 +12.5), ceil(_starBackgroundView.center.y));
        [self.contentView addSubview:self.markLb];
        
        NSString *description = @"";
        CGSize descriptionSize =[description sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 * widthFloat]}];
        self.descriptionLb = [FanShuToolClass createLabelWithFrame:CGRectMake(96 * widthFloat, size.height +(15 +6) * heightFloat +15 +6 * heightFloat, ScreenWidth -70 * widthFloat -96 * widthFloat, descriptionSize.height) text:description font:[UIFont systemFontOfSize:14 * widthFloat] textColor:Color(65, 65, 65, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.descriptionLb];
        
        self.buyBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -70 * widthFloat, self.descriptionLb.frame.origin.y, 60 * widthFloat, 30 * heightFloat) title:@"购票" titleColor:[UIColor whiteColor] target:self action:@selector(gotoCinemaEvents:) tag:CinemaTableViewCellBuyEvents];
        self.buyBtn.layer.cornerRadius = 5.0f;
        self.buyBtn.layer.masksToBounds = YES;
        self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:15 * widthFloat];
        self.buyBtn.backgroundColor = Color(252, 186, 0, 1.0);
        [self.contentView addSubview:self.buyBtn];
        
        
        NSArray *types = @[@"冒险",@"冒险",@"冒险"];
        CGSize typeSize =[types[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * widthFloat]}];
        _typeView = [FanShuToolClass createViewWithFrame:CGRectMake(96 * widthFloat,  size.height +(15 +8) * heightFloat +10 +8 * heightFloat +descriptionSize.height +5, 40 +3 * typeSize.width, typeSize.height) backgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_typeView];
        
        for (int i = 0; i < types.count; i ++) {
            UILabel *lb = [FanShuToolClass createLabelWithFrame:CGRectMake((20 + typeSize.width)* i, 0, typeSize.width, typeSize.height) text:types[i] font:[UIFont systemFontOfSize:13 * widthFloat] textColor:Color(65, 65, 65, 1.0) alignment:NSTextAlignmentLeft];
            if (i < types.count -1) {
                UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(typeSize.width +10 + i * (20 + typeSize.width), 0, 1, 6) backgroundColor:Color(222, 222, 222, 1.0)];
                line.center = CGPointMake(typeSize.width +10 + i * (20 + typeSize.width) + 0.5, lb.center.y);
                [_typeView addSubview:line];
                if (i == 0) {
                    _firstLine = line;
                }else{
                    _secLine = line;
                }
            }
            switch (i) {
                case 0:
                    self.firstType = lb;
                    break;
                case 1:
                    self.secType = lb;
                    break;
                case 2:
                    self.thirdType = lb;
                    break;
                default:
                    break;
            }
            [_typeView addSubview:lb];
        }
    }
    return self;
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = CGRectMake(96 * widthFloat, _nameSize.height +(15 +6) * heightFloat, 75 +12, 15);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < 5; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * (15 +3), 0, 15, frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)gotoCinemaEvents:(UIButton *)btn
{
    NSInteger event;
    if ([self.delegate respondsToSelector:@selector(gotoCinemaTableViewCellEvents:indexPath:)]) {
        if (btn.tag == CinemaTableViewCellBuyEvents) {
            if ([btn.titleLabel.text isEqualToString:@"购票"]) {
                event = CinemaTableViewCellBuyEvents;
            }else{
                event = CinemaTableViewCellPreSaleEvents;
            }
            [self.delegate gotoCinemaTableViewCellEvents:event indexPath:self.indexPath];
        }else if (btn.tag == CinemaTableViewCellPlayEvents){
            [self.delegate gotoCinemaTableViewCellEvents:btn.tag indexPath:self.indexPath];
        }
    }
}

- (void)configCellWithModel:(HotFilm *)hotFilm
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,hotFilm.cover]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLb.text = hotFilm.name;
    CGSize size =[self.nameLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 * widthFloat]}];
    CGSize tagSize;
    if (hotFilm.tags.count != 0) {
        tagSize = [hotFilm.tags[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10 * widthFloat]}];
    }
    if ([hotFilm.is_hot boolValue]) {
        self.nameLb.frame = CGRectMake(96 * widthFloat, 15 * heightFloat, size.width > (ScreenWidth -96 * widthFloat -17 * widthFloat -tagSize.width -60 * widthFloat) ? (ScreenWidth -96 * widthFloat -17 * widthFloat -tagSize.width -60 * widthFloat) : size.width, size.height);
    }else{
        self.nameLb.frame = CGRectMake(96 * widthFloat, 15 * heightFloat, size.width > (ScreenWidth -96 * widthFloat -17 * widthFloat -tagSize.width) ? (ScreenWidth -96 * widthFloat -17 * widthFloat -tagSize.width) : size.width, size.height);
    }
    if (hotFilm.tags.count != 0) {
        self.is3DImg.frame = CGRectMake(96 * widthFloat + self.nameLb.frame.size.width +5, self.nameLb.center.y, ceil(tagSize.width) +4, 16);
        self.is3DImg.center = CGPointMake(ceil(96 * widthFloat + self.nameLb.frame.size.width +5 +tagSize.width / 2), ceil(self.nameLb.center.y));
        [self.is3DImg setTitle:hotFilm.tags[0] forState:UIControlStateNormal];
        [self.is3DImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.is3DImg.hidden = YES;
    }
    self.descriptionLb.text = hotFilm.sketch;
    CGSize descriptionSize =[self.descriptionLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 * widthFloat]}];
    self.descriptionLb.frame = CGRectMake(96 * widthFloat, size.height +(15 +8) * heightFloat +10 +8 * heightFloat, ScreenWidth -70 * widthFloat -96 * widthFloat, descriptionSize.height);
    if ([hotFilm.presell boolValue]) {
        [self.buyBtn setTitle:@"预售" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(25, 153, 232, 1.0);
    }else{
        [self.buyBtn setTitle:@"购票" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(252, 186, 0, 1.0);
    }
    if ([hotFilm.is_hot boolValue]) {
        self.hotImg.hidden = NO;
    }else{
        self.hotImg.hidden = YES;
    }
    NSArray *types = hotFilm.label;
    CGSize typeSize = CGSizeMake(0, 0);
    CGFloat typesWid = 0;
    if (types.count != 0) {
        typeSize = [types[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * widthFloat]}];
        for (int i = 0; i < types.count; i ++) {
            switch (i) {
                case 0:
                {
                    CGSize firstSize =[types[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * widthFloat]}];
                    self.firstType.text = types[0];
                    self.firstType.frame = CGRectMake(0, 0, firstSize.width, firstSize.height);
                    typesWid = firstSize.width;
                }
                    break;
                case 1:
                {
                    CGSize secSize =[types[1] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * widthFloat]}];
                    self.secType.text = types[1];
                    self.secType.frame = CGRectMake(self.firstType.frame.size.width +20, 0, secSize.width, secSize.height);
                    _firstLine.center = CGPointMake(self.firstType.frame.size.width +10 +0.5, self.secType.center.y);
                    typesWid = self.firstType.frame.size.width +20 +secSize.width;
                }
                    break;
                case 2:
                {
                    CGSize trdSize =[types[2] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * widthFloat]}];
                    self.thirdType.text = types[2];
                    self.thirdType.frame = CGRectMake(self.firstType.frame.size.width +20 +self.secType.frame.size.width +20, 0, trdSize.width, trdSize.height);
                    _secLine.center = CGPointMake(self.firstType.frame.size.width +10 +0.5 +0.5 +10 +self.secType.frame.size.width +10 +0.5, self.thirdType.center.y);
                    typesWid = self.firstType.frame.size.width +20 +self.secType.frame.size.width +20 +trdSize.width;
                }
                    break;
                default:
                    break;
            }
        }
    }
    _typeView.frame = CGRectMake(96 * widthFloat,  size.height +(15 +8) * heightFloat +10 +8 * heightFloat +descriptionSize.height +5, typesWid, typeSize.height);
    _typeView.layer.masksToBounds = YES;
    _starForegroundView.frame = CGRectMake(96 * widthFloat, _nameSize.height +(15 +6) * heightFloat, 87 * (hotFilm.stars) / 10, 15);
    self.markLb.text = [NSString stringWithFormat:@"%.1f",hotFilm.stars];
    [hotFilm.trailer isEqualToString:@""] ? (self.playBtn.hidden = YES) : (self.playBtn.hidden = NO);
}

@end
