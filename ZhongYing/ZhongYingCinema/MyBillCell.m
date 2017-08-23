//
//  MyBillCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/6.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyBillCell.h"

@implementation MyBillCell

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
        self.weekLb = [FanShuToolClass createLabelWithFrame:CGRectMake(18, 12, 40, 15) text:@"周一" font:[UIFont systemFontOfSize:15] textColor:Color(100, 100, 100, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.weekLb];
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15, 12 +15 +7, 40, 12) text:@"07-18" font:[UIFont systemFontOfSize:12] textColor:Color(100, 100, 100, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.dateLb];
        
        self.billImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(15 +40 +15, 6, 43, 43) image:nil tag:34];
        self.billImg.layer.cornerRadius = 22;
        self.billImg.clipsToBounds = YES;
        [self.contentView addSubview:self.billImg];
        
        self.priceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15 +40 +15 +43 +20, 10, 100, 15) text:@"-45.00" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.priceLb];
        
        self.billDetailsLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15 +40 +15 +43 +20, 10 +15 +7, 200, 15) text:@"小爆米花1份+可乐1杯" font:[UIFont systemFontOfSize:15] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.billDetailsLb];
        
    }
    return self;
}

- (void)configCellWithModel:(Bill *)bill
{
    self.weekLb.text = [NSString getWeekDayFordate:bill.created_time];
    self.dateLb.text = [[NSString stringWithFormat:@"%zd",bill.created_time] transforTomyyyyMMddWithFormatter:@"MM-dd"];
    switch (bill.operate_type) {
        case 1: // 电影票
            self.billImg.image = [UIImage imageNamed:@"bill_ticket"];
            break;
        case 2: // 卖品
            self.billImg.image = [UIImage imageNamed:@"bill_package"];
            break;
        case 3: // 充值
            self.billImg.image = [UIImage imageNamed:@"bill_recharge"];
            break;
        case 4: // 退票
            self.billImg.image = [UIImage imageNamed:@"bill_refund"];
            break;
        case 5: // 退货
            self.billImg.image = [UIImage imageNamed:@"bill_refund"];
            break;
        case 6: // 手续费
            self.billImg.image = [UIImage imageNamed:@"bill_refund"];
            break;
        default:
            break;
    }
    if (bill.type == 1) {
        self.priceLb.text = [NSString stringWithFormat:@"-%.2f",bill.balance * 1.0];
    }else{
        self.priceLb.text = [NSString stringWithFormat:@"+%.2f",bill.balance * 1.0];
    }
    self.billDetailsLb.text = bill.remark;
}

@end
