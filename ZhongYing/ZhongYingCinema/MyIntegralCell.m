//
//  MyIntegralCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/9.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyIntegralCell.h"

@implementation MyIntegralCell

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
        self.goodsImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(29, 9, 66, 92) image:[UIImage imageNamed:[NSString stringWithFormat:@"movie_poster_%zd",arc4random() % 3 +1]] tag:100];
        [self.contentView addSubview:self.goodsImg];
        
        self.goodsTypeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(29 +66 +22, 22, 150, 15) text:@"电影票" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.goodsTypeLb];
        
        self.goodsNameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(29 +66 +22, 22 +15 +9, 200, 15) text:@"机械师2：复活" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.goodsNameLb];
        
        self.integralLb = [FanShuToolClass createLabelWithFrame:CGRectMake(29 +66 +22, 22 +15 +9 +15 +11, 150, 15) text:@"积分 20" font:[UIFont systemFontOfSize:15] textColor:Color(0, 144, 230, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.integralLb];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.integralLb.text];
        NSRange range = [self.integralLb.text rangeOfString:@"积分"];
        [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:Color(53, 163, 234, 1.0)} range:range];
        self.integralLb.attributedText = str;
    }
    return self;
}

- (void)configCellWithModel:(Shop *)shop
{
    [self.goodsImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,shop.cover]] placeholderImage:[UIImage imageNamed:@""]];
    if (shop.shop_type == 1) {
        self.goodsTypeLb.text = @"电影票";
        self.goodsNameLb.text = shop.name;
    }else if(shop.shop_type == 2){
        self.goodsTypeLb.text = @"观影套餐";
        self.goodsNameLb.text = shop.detail;
    }else{
        self.goodsTypeLb.text = @"纪念品";
        self.goodsNameLb.text = shop.detail;
    }
    
    self.integralLb.text = [NSString stringWithFormat:@"积分 %zd",shop.score];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.integralLb.text];
    NSRange range = [self.integralLb.text rangeOfString:@"积分"];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:Color(53, 163, 234, 1.0)} range:range];
    self.integralLb.attributedText = str;
}

@end
