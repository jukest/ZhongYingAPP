//
//  MovePictureSliderCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "MovePictureSliderCell.h"
#import "UIImageView+WebCache.h"




@implementation MovePictureSliderCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.imageView = imgView;
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)setModel:(NSString *)imgURL {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,imgURL]] placeholderImage:[UIImage imageNamed:@"placeholder"]];

}
@end
