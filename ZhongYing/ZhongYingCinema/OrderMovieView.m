//
//  OrderMovieView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/27.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "OrderMovieView.h"
#import "UIImageView+WebCache.h"

@implementation OrderMovieView

- (instancetype)initWithFrame:(CGRect)frame movieMessage:(NSDictionary *)movie
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.orderImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(24, 18, 60 +10, 80 +15) color:[UIColor grayColor]];
        [self.orderImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,movie[@"cover"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self addSubview:self.orderImg];
        
        self.priceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(24 + 60 +10 + 20, 18, 100, 20) text:[NSString stringWithFormat:@"￥%.2f",[movie[@"price"] floatValue]] font:[UIFont systemFontOfSize:20 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.priceLb];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(24 + 60 +10 + 20, 18 +20 +10, ScreenWidth -(24 +60 +10 +20 +12), 15) text:movie[@"name"] font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(65, 65, 65, 1.0) alignment:NSTextAlignmentLeft];
        [self addSubview:self.nameLb];
        
        self.timeAndHallLb = [FanShuToolClass createLabelWithFrame:CGRectMake(24 + 60 +10 + 20, 18 +20 +10 +15 +10, ScreenWidth -(24 +60 +10 +20 +12), 15) text:[NSString stringWithFormat:@"%@  (%@)  %@",movie[@"forHuman"],movie[@"hall_type"],movie[@"hall"]] font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(65, 65, 65, 1.0) alignment:NSTextAlignmentLeft];
        [self addSubview:self.timeAndHallLb];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.timeAndHallLb.text];
        NSRange range = [self.timeAndHallLb.text rangeOfString:[NSString stringWithFormat:@"%@",movie[@"forHuman"]]];
        [str addAttributes:@{NSForegroundColorAttributeName : Color(248, 91, 118, 1.0)} range:range];
        NSRange range1 = [self.timeAndHallLb.text rangeOfString:[NSString stringWithFormat:@"(%@)  %@",movie[@"hall_type"],movie[@"hall"]]];
        [str addAttributes:@{NSForegroundColorAttributeName : Color(130, 130, 130, 1.0)} range:range1];
        self.timeAndHallLb.attributedText = str;
        
        self.seatsLb = [FanShuToolClass createLabelWithFrame:CGRectMake(24 + 60 +10 + 20, 18 +20 +10 +15 +10 +15 +10, ScreenWidth -(24 +60 +10 +20 +12), 15) text:movie[@"seats"] font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(65, 65, 65, 1.0) alignment:NSTextAlignmentLeft];
        [self addSubview:self.seatsLb];
    }
    return self;
}


@end
