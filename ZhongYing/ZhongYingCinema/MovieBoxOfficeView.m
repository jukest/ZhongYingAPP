//
//  MovieBoxOfficeView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MovieBoxOfficeView.h"

@implementation MovieBoxOfficeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 8, 65, 20) text:@"票房" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLb];
        
        NSArray *texts = @[@"",@"",@""];
        for (int i = 0; i < 3; i ++) {
            UILabel *lb = [FanShuToolClass createLabelWithFrame:CGRectMake(i * ScreenWidth / 3, 36, ScreenWidth / 3, 40) text:texts[i] font:[UIFont systemFontOfSize:20] textColor:Color(209, 50, 50, 1.0) alignment:NSTextAlignmentCenter];
            lb.numberOfLines = 0;
            NSRange range = [texts[i] rangeOfString:@"万"];
            if (range.location == NSNotFound) {
                range = [texts[i] rangeOfString:@"\n"];
            }
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:texts[i]];
//            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(range.location, [texts[i] length] -range.location)];
//            [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(range.location, [texts[i] length] -range.location)];
//            lb.attributedText = str;
            [self addSubview:lb];
            switch (i) {
                case 0:
                    self.todayLb = lb;
                    break;
                case 1:
                    self.historyLb = lb;
                    break;
                case 2:
                    self.rankLb = lb;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)configMovieBoxOfficeViewWithDictionary:(NSDictionary *)box_office
{
    NSMutableArray *texts = [[NSMutableArray alloc] init];
    if ([box_office[@"today"] integerValue] / 10000 == 0) {
        
        [texts addObject:[NSString stringWithFormat:@"%@\n今日票房",[self insertIntoString:[NSString stringWithFormat:@"%zd",[box_office[@"today"] integerValue] / 10000]]]];
    }else{
        
        [texts addObject:[NSString stringWithFormat:@"%@万\n今日票房",[self insertIntoString:[NSString stringWithFormat:@"%zd",[box_office[@"today"] integerValue] / 10000]]]];
    }
    if ([box_office[@"history"] integerValue] / 10000 == 0) {
        [texts addObject:[NSString stringWithFormat:@"%@\n历史票房",[self insertIntoString:[NSString stringWithFormat:@"%zd",[box_office[@"history"] integerValue] / 10000]]]];
    }else{
        [texts addObject:[NSString stringWithFormat:@"%@万\n历史票房",[self insertIntoString:[NSString stringWithFormat:@"%zd",[box_office[@"history"] integerValue] / 10000]]]];
    }
    [texts addObject:[NSString stringWithFormat:@"%@\n票房排行",box_office[@"rank"]]];
    
    for (int i = 0; i < 3; i ++) {
        UILabel *lb;
        switch (i) {
            case 0:
                lb = self.todayLb;
                break;
            case 1:
                lb = self.historyLb;
                break;
            case 2:
                lb = self.rankLb;
                break;
            default:
                break;
        }
        NSRange range = [texts[i] rangeOfString:@"万"];
        if (range.location == NSNotFound) {
            range = [texts[i] rangeOfString:@"\n"];
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:texts[i]];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(range.location, [texts[i] length] -range.location)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(range.location, [texts[i] length] -range.location)];
        lb.attributedText = str;
    }
}

- (NSString *)insertIntoString:(NSString *)str
{
    NSMutableString *mStr = [NSMutableString stringWithString:str];
    if ([str integerValue] / 1000 > 0) {
        [mStr insertString:@"," atIndex:str.length -3];
    }
    return mStr;
}

@end
