//
//  ExchangeRecordCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/9.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ExchangeRecordCell.h"

@implementation ExchangeRecordCell

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
        self.goodsImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 15, 46, 46) image:[UIImage imageNamed:@""] tag:100];
        [self.contentView addSubview:self.goodsImg];
        
        self.goodsTypeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +42 +18, 16, ScreenWidth -12 -42 -18, 15) text:@"" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.goodsTypeLb];
        
        self.integralLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +42 +18, 16 +15 +10, 150, 15) text:@"" font:[UIFont systemFontOfSize:16] textColor:Color(0, 144, 230, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.integralLb];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.integralLb.text];
        NSRange range = [self.integralLb.text rangeOfString:@"积分"];
        [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:Color(53, 163, 234, 1.0)} range:range];
        self.integralLb.attributedText = str;
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -13 -150, 16 +15 +10, 150, 13) text:@"" font:[UIFont systemFontOfSize:15] textColor:Color(90, 90, 90, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.dateLb];
    }
    return self;
}

- (void)configCellWithModel:(Record *)record
{
    NSInteger i = 0;
    switch (record.shop_type) {
        case 1:
            i = 1;
            break;
        case 2:
            i = 2;
            break;
        case 3:
            i = 2;
            break;
        case 4:
            i = 3;
            break;
        default:
            break;
    }
    self.goodsImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"Integral_goods_%zd",i]];
    self.goodsTypeLb.text = record.name;
    self.integralLb.text = [NSString stringWithFormat:@"积分 %zd",record.score];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.integralLb.text];
    NSRange range = [self.integralLb.text rangeOfString:@"积分"];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:Color(53, 163, 234, 1.0)} range:range];
    self.integralLb.attributedText = str;
    
    self.dateLb.text = [record.created_time transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"];
}

@end
