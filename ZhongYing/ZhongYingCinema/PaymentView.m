//
//  PaymentView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/27.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "PaymentView.h"

@interface PaymentView ()

@property(nonatomic,strong) OrderMovieView *movieView;

@end
@implementation PaymentView

- (instancetype)initWithFrame:(CGRect)frame type:(PaymentShowMessage)type packageArr:(NSArray *)packages movieMessage:(NSDictionary *)message
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *backImgView = [FanShuToolClass createImageViewWithFrame:frame image:[UIImage imageNamed:@"payment_background"] tag:777];
        [self addSubview:backImgView];
        if (type == PaymentShowMovieMessage) {
            self.movieView = [[OrderMovieView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130) movieMessage:message];
        }else{
            self.movieView = [[OrderMovieView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        }
        [self addSubview:self.movieView];
        
        for (NSInteger i = 0; i < packages.count; i ++) {
            UIView *bottomView = [FanShuToolClass createViewWithFrame:CGRectMake(0, self.movieView.frame.size.height + i * 65, ScreenWidth, 65) backgroundColor:[UIColor clearColor]];
            [self addSubview:bottomView];
            
            UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(26, 0, ScreenWidth -52, 1) backgroundColor:Color(223, 223, 223, 1.0)];
            [bottomView addSubview:lineView];
            if (type == PaymentNotShowMovieMessage && i == 0) {
                lineView.frame = CGRectMake(26, 0, ScreenWidth -52, 0);
            }
            
            NSDictionary *dict = packages[i];
            UILabel *packageLb = [FanShuToolClass createLabelWithFrame:CGRectMake(24, lineView.frame.origin.y +10, ScreenWidth -48, 45) text:[NSString stringWithFormat:@"%@\n%@",dict[@"name"],dict[@"detail"]] font:[UIFont systemFontOfSize:16 * widthFloat] textColor:Color(65, 65, 65, 1.0) alignment:NSTextAlignmentLeft];
            packageLb.numberOfLines = 0;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:packageLb.text];
            NSRange range = NSMakeRange([dict[@"name"] length] +1, [dict[@"detail"] length]);
            [str addAttributes:@{NSForegroundColorAttributeName : Color(40, 40, 40, 1.0)} range:range];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:5];
            [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, packageLb.text.length)];
        
            if (type == PaymentNotShowMovieMessage) {
                NSRange range1 = NSMakeRange(0, [dict[@"name"] length]);
                [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18 * widthFloat]} range:range1];
                [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14 * widthFloat]} range:range];
            }
            packageLb.attributedText = str;
            
            [bottomView addSubview:packageLb];
        }
    }
    return self;
}

@end
