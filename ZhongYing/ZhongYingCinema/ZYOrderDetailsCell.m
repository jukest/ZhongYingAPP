//
//  ZYOrderDetailsCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYOrderDetailsCell.h"
#import "UIImageView+WebCache.h"


@interface ZYOrderDetailsCell()
//@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
//@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *goodDetailLabel;
//@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic, weak) UIImageView *foodImageView;
@property (nonatomic, weak) UILabel *foodNameLabel;
@property (nonatomic, weak) UILabel *foodNumberLabel;
@property (nonatomic, weak) UILabel *foodPriceLabel;

@property (nonatomic, weak) UIView *lineView;

@end

@implementation ZYOrderDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.foodImageView = imageView;
    [self addSubview:imageView];
    
    UILabel *goodNameLabel = [FanShuToolClass createLabelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    self.foodNameLabel = goodNameLabel;
    [self addSubview:goodNameLabel];
    
    UILabel *numberLabel = [FanShuToolClass createLabelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    self.foodNumberLabel = numberLabel;
    [self addSubview:numberLabel];
    
    UILabel *priceLabel = [FanShuToolClass createLabelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    self.foodPriceLabel = priceLabel;
    [self addSubview:priceLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor lightGrayColor];
    self.lineView = lineView;
    [self addSubview:lineView];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.foodImageView.frame = CGRectMake(20, 10, self.height - 20, self.height - 20);
    
    self.foodNameLabel.frame = CGRectMake(CGRectGetMaxX(self.foodImageView.frame)+10, 12, self.width - CGRectGetMaxX(self.foodImageView.frame) - 10 , 20);
    
    self.foodNumberLabel.frame = CGRectMake(self.foodNameLabel.x, CGRectGetMaxY(self.foodNameLabel.frame) + 10, self.foodNameLabel.width, 20);
    
    self.foodPriceLabel.frame = CGRectMake(self.foodNumberLabel.x, CGRectGetMaxY(self.foodNumberLabel.frame) + 10, self.foodNameLabel.width, 20);
    
    self.lineView.frame = CGRectMake(0, self.height - 1, ScreenWidth, 1);
}


- (void)setOrder:(Order *)order {
    _order = order;
    
    self.foodImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,order.cover];
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.foodNameLabel.text = order.name;
    
    self.foodNumberLabel.text = [NSString stringWithFormat:@"数量：%d",order.number];
    if (self.type == 1) {
        
        self.foodPriceLabel.text = [NSString stringWithFormat:@"价格：￥%.2f",[order.price floatValue]];
    } else {
        self.foodPriceLabel.text = [NSString stringWithFormat:@"价格：%.2f积分",[order.price floatValue]];
        
    }
    
    
}

- (void)setType:(NSInteger)type {
    _type = type;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
