//
//  CinemaCollectionViewCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "CinemaCollectionViewCell.h"

@interface CinemaCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *hotBtn;

@property (nonatomic, strong) UILabel *cinemaTitleLabel;

/** 购票或预售 */
@property (nonatomic, strong) UIButton *buyBtn;

/** 电影描述 */
@property (nonatomic, strong) UILabel *descripLabel;

/** 是否有预告片 */
@property (nonatomic, strong) UIButton *playBtn;






@end

@implementation CinemaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
        
    }
    return self;
}

#pragma mark -- 初始化

- (void)setupUI {
    
    //电影图片
    UIImageView *imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, ItemBaseViewConllectViewCellFilmImgHeight)];
    imgeView.userInteractionEnabled = NO;
    [self addSubview:imgeView];
    self.imageView = imgeView;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;

    
    //播放预告片
    self.playBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 25,25) image:[UIImage imageNamed:@"movie_play"] target:nil action:nil tag:CinemaConllectionViewCellPlayEvents];
    [self.playBtn addTarget:self action:@selector(gotoCinemaEvents:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.backgroundColor = [UIColor clearColor];
    self.playBtn.imageView.contentMode = UIViewContentModeCenter;
    self.playBtn.center = self.imageView.center;
    [self addSubview:self.playBtn];

    
    //电影热度
    self.hotBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 30 , 40) title:@"今日\n最热" titleColor:[UIColor whiteColor] target:nil action:nil tag:3000];
    self.hotBtn.titleLabel.font = [UIFont systemFontOfSize:12 * widthFloat];
    self.hotBtn.titleLabel.numberOfLines = 0;
    [self.hotBtn setBackgroundImage:[UIImage imageNamed:@"movie_hot"] forState:UIControlStateNormal];
    [self.imageView addSubview:self.hotBtn];

    //电影名字
    NSString *name = @"鲁滨逊漂流记";
    self.cinemaTitleLabel = [FanShuToolClass createLabelWithFrame:CGRectZero text:name font:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    self.cinemaTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.cinemaTitleLabel];
    
    
    //购票
    self.buyBtn = [FanShuToolClass createButtonWithFrame:CGRectZero title:@"购票" titleColor:[UIColor whiteColor] target:self action:@selector(gotoCinemaEvents:) tag:CinemaConllectionViewCellBuyEvents];
    self.buyBtn.layer.cornerRadius = 5.0f;
    self.buyBtn.layer.masksToBounds = YES;
    self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    self.buyBtn.backgroundColor = Color(252, 186, 0, 1.0);
    [self addSubview:self.buyBtn];
    
    //描述
    NSString *description = @"";
    self.descripLabel = [FanShuToolClass createLabelWithFrame:CGRectZero text:description font:[UIFont systemFontOfSize:12] textColor:Color(65, 65, 65, 1.0) alignment:NSTextAlignmentLeft];
    self.descripLabel.numberOfLines = 2;
    self.descripLabel.userInteractionEnabled = NO;
//    [self addSubview:self.descripLabel];
    

    
}


- (void)setHotFilm:(HotFilm *)hotFilm {
    _hotFilm = hotFilm;
    
    //图片
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,hotFilm.cover]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //热度
    if ([hotFilm.is_hot boolValue]) {
        self.hotBtn.hidden = NO;
    }else{
        self.hotBtn.hidden = YES;
    }
    
    //预告片
    [hotFilm.trailer isEqualToString:@""] ? (self.playBtn.hidden = YES) : (self.playBtn.hidden = NO);

    //名字
    NSString *name = hotFilm.name;
    CGSize size =[name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    if (size.width > self.width - ItemBaseViewConllectViewCellBuyBtnW  ) {
        
        self.cinemaTitleLabel.frame = CGRectMake(0, (CGRectGetMaxY(self.imageView.frame) + ItemBaseViewConllectViewCellMarge) , self.width - ItemBaseViewConllectViewCellBuyBtnW , ItemBaseViewConllectViewCellFilmNameLabelH);

    } else {
        
        self.cinemaTitleLabel.frame = CGRectMake(0, (CGRectGetMaxY(self.imageView.frame) + ItemBaseViewConllectViewCellMarge), size.width, ItemBaseViewConllectViewCellFilmNameLabelH);
    }
    
    self.cinemaTitleLabel.text = name;
    
    
    
    //购票
    if ([hotFilm.presell boolValue]) {
        [self.buyBtn setTitle:@"预售" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(25, 153, 232, 1.0);
    }else{
        [self.buyBtn setTitle:@"购票" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(252, 186, 0, 1.0);
    }
    
    self.buyBtn.frame = CGRectMake(self.width - ItemBaseViewConllectViewCellBuyBtnW, self.cinemaTitleLabel.y, ItemBaseViewConllectViewCellBuyBtnW, self.cinemaTitleLabel.height);
    
    //描述
//    self.descripLabel.text = hotFilm.sketch;
    
//    self.descripLabel.frame = CGRectMake(0, (CGRectGetMaxY(self.cinemaTitleLabel.frame ) + 10 ), self.width, ItemBaseViewConllectViewCellDescrip);
    
    
    
    
}


- (void)gotoCinemaEvents:(UIButton *)btn
{
    NSInteger event;
    if ([self.delegate respondsToSelector:@selector(gotoCinemaCollectionViewCellEvents:indexPath:)]) {
        if (btn.tag == CinemaConllectionViewCellBuyEvents) {
            if ([btn.titleLabel.text isEqualToString:@"购票"]) {
                event = CinemaConllectionViewCellBuyEvents;
            }else{
                event = CinemaConllectionViewCellPreSaleEvents;
            }
            [self.delegate gotoCinemaCollectionViewCellEvents:event indexPath:self.indexPath];
        }else if (btn.tag == CinemaConllectionViewCellPlayEvents){
            [self.delegate gotoCinemaCollectionViewCellEvents:btn.tag indexPath:self.indexPath];
        }
    }
}


@end
