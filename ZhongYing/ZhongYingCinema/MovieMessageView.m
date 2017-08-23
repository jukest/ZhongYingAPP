//
//  MovieMessageView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieMessageView.h"
#import "UIImageView+WebCache.h"


@implementation MovieMessageView

- (instancetype)initWithFrame:(CGRect)frame film:(HotFilm *)film type:(NSString *)type
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if ([type isEqualToString:@"海报"]) {
            UIView *backgroundView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 64, ScreenWidth, 192) backgroundColor:[UIColor clearColor]];
            [self addSubview:backgroundView];
            
            self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 18, 115, 150) color:[UIColor clearColor]];
            [self.movieImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,film.cover]] placeholderImage:[UIImage imageNamed:@""]];
            [backgroundView addSubview:self.movieImg];
            
            self.playBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 50 * widthFloat, 50 * widthFloat) image:[UIImage imageNamed:@"movie_play"] target:self action:@selector(gotoMovieMessageEvents:) tag:MovieMessageViewPlayEvents];
            self.playBtn.center = CGPointMake(self.movieImg.frame.size.width / 2, self.movieImg.frame.size.height / 2);
            [self.movieImg addSubview:self.playBtn];
            if ([film.trailer isEqualToString:@""]) {
                self.playBtn.hidden = YES;
            }else{
                self.playBtn.hidden = NO;
            }
            
            self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +115 +15, 18 +10, 200, 25) text:film.name font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
            [backgroundView addSubview:self.nameLb];
            
            self.foreNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +115 +15, 18 +10 +25, 200, 15) text:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
            [backgroundView addSubview:self.foreNameLb];

            
            self.typeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +115 +15, 18 +10 +25 +15 +12, 200, 15) text:[film.label componentsJoinedByString:@" "] font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
            [backgroundView addSubview:self.typeLb];
            
            self.addressLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +115 +15, 18 +10 +25 +15 +12 +15 +12, ScreenWidth -12-115-15-12, 15) text:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
            [backgroundView addSubview:self.addressLb];
            
            self.releaseTimeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +115 +15, 18 +10 +25 +15 +12 +15 +12 +15 +12, 200, 15) text:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
            [backgroundView addSubview:self.releaseTimeLb];
            self.backgroundView = backgroundView;
        }else{

        }
        
        UIView *bottomView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 192 +64, ScreenWidth, 160 +frame.size.height -352 -64) backgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        NSString *content = @"";
        self.contentLb = [FanShuToolClass createLabelWithFrame:CGRectMake(16, 15, ScreenWidth -32, 70 +frame.size.height -352 -64) text:content font:[UIFont systemFontOfSize:16] textColor:Color(56, 56, 56, 1.0) alignment:NSTextAlignmentLeft];
        self.contentLb.numberOfLines = 0;
        
        // 设置文字行距
        NSString *titleLabelText = self.contentLb.text;
        self.contentLb.attributedText = [FanShuToolClass getAttributeStringWithContent:titleLabelText withLineSpaceing:6];
        //[self.contentLb sizeToFit];
        [bottomView addSubview:self.contentLb];
        self.contentLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreDescription:)];
        [self.contentLb addGestureRecognizer:tap];
        
        self.moreBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 15 +70 +frame.size.height -352 -64, ScreenWidth, 25) image:[UIImage imageNamed:@"movie_more"] target:self action:@selector(gotoMovieMessageEvents:) tag:MoreDescriptionEvent];
        if (frame.size.height == 352 +64) {
            self.moreBtn.selected = NO;
        }else{
            self.moreBtn.selected = YES;
        }
        
        [self.moreBtn setImage:[UIImage imageNamed:@"movie_close"] forState:UIControlStateSelected];
        [bottomView addSubview:self.moreBtn];
        
        NSArray *btnTitles = @[@"收藏",@"我要评论"];
        NSArray *btnImgs = @[@"movie_not_collect",@"movie_comment"];
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [FanShuToolClass createButtonWithFrame:CGRectMake(15 +i * ((ScreenWidth -50) / 2 +20), 15 +70 +frame.size.height -352 -64 +25, (ScreenWidth -50) / 2, 38) title:btnTitles[i] titleColor:Color(56, 56, 56, 1.0) target:self action:@selector(gotoMovieMessageEvents:) tag:10000];
            [btn setImage:[UIImage imageNamed:btnImgs[i]] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.backgroundColor = Color(234, 234, 234, 1.0);
            btn.layer.cornerRadius = 5.0;
            btn.layer.masksToBounds = YES;
            if (i == 0) {
                self.collectBtn = btn;
                [self.collectBtn setImage:[UIImage imageNamed:@"movie_collect"] forState:UIControlStateSelected];
                [self.collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
                self.collectBtn.tag = MovieCollectEvent;
                self.collectBtn.selected = NO;
            }else{
                self.commentBtn = btn;
                self.commentBtn.tag = MovieCommentEvent;
            }
            [bottomView addSubview:btn];
        }
    }
    return self;
}

- (void)gotoMovieMessageEvents:(UIButton *)btn
{
    if (btn.tag == MovieCollectEvent) {
        //btn.selected = !btn.selected;
    }
    if (btn.tag == MoreDescriptionEvent) {
        self.moreBtn.selected = !self.moreBtn.selected;
    }
    if ([self.delegate respondsToSelector:@selector(jumpToMovieMessageViewEvent:)]) {
        [self.delegate jumpToMovieMessageViewEvent:btn.tag];
    }
}

- (void)moreDescription:(UIGestureRecognizer *)tap
{
    self.moreBtn.selected = !self.moreBtn.selected;
    if ([self.delegate respondsToSelector:@selector(jumpToMovieMessageViewEvent:)]) {
        [self.delegate jumpToMovieMessageViewEvent:MoreDescriptionEvent];
    }
}

- (void)configMovieMessageViewWithModel:(Movie *)movie
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,movie.cover]] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLb.text = movie.name;
    self.foreNameLb.text = movie.english_name;
    self.addressLb.text = [NSString stringWithFormat:@"%@ / %@分钟",movie.source,movie.length];
    self.typeLb.text = [movie.label componentsJoinedByString:@" "];
    self.releaseTimeLb.text = [NSString stringWithFormat:@"%@%@上映",[movie.release_time transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"],movie.release_area];
    if (movie.collection) {
        self.collectBtn.selected = YES;
    }else{
        self.collectBtn.selected = NO;
    }
    self.contentLb.text = movie.detail;
    // 设置文字行距
    NSString *titleLabelText = self.contentLb.text;
    self.contentLb.attributedText = [FanShuToolClass getAttributeStringWithContent:titleLabelText withLineSpaceing:6];
    if ([movie.trailer isEqualToString:@""]) {
        self.playBtn.hidden = YES;
    }else{
        self.playBtn.hidden = NO;
    }
}

@end
