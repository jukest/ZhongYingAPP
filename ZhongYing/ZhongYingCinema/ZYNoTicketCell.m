//
//  ZYNoTicketCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYNoTicketCell.h"
#import "WXCalender.h"

@implementation ZYNoTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Color(245, 245, 245, 1.0);
        
        UIView *view = [FanShuToolClass createViewWithFrame:CGRectMake(0, 18, ScreenWidth, 110) backgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:view];
        
        // 电影图片
        self.movieImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(15, 10, 50, 90) color:[UIColor whiteColor]];
        self.movieImg.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:self.movieImg];
        
        // 电影标题
        CGSize nameSize = [FanShuToolClass createString:@"" font:[UIFont systemFontOfSize:17 * widthFloat] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth, 40)];
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(90, 10, nameSize.width, 40) text:@"" font:[UIFont systemFontOfSize:17 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [view addSubview:self.nameLb];
        
        // 电影倒计时
        self.timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(100+nameSize.width, 10, ScreenWidth-115-nameSize.width, 40) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(0, 151, 235, 1.0) alignment:NSTextAlignmentLeft];
        self.timeLb.numberOfLines = 0;
        self.timeLb.adjustsFontSizeToFitWidth = YES;
        [view addSubview:self.timeLb];
        
        // 电影描述
        self.descriptionLb = [FanShuToolClass createLabelWithFrame:CGRectMake(90, 50, ScreenWidth-90 -56 * widthFloat -14, 25) text:@"" font:[UIFont systemFontOfSize:16 * widthFloat] textColor:Color(40, 40, 40, 1.0) alignment:NSTextAlignmentLeft];
        [view addSubview:self.descriptionLb];
        
        // 电影价格
        self.priceLb = [FanShuToolClass createLabelWithFrame:CGRectMake(90, 80, 100, 35) text:@"" font:[UIFont systemFontOfSize:14] textColor:Color(40, 40, 40, 1.0) alignment:NSTextAlignmentLeft];
        [view addSubview:self.priceLb];
//        self.priceLb.backgroundColor = [UIColor redColor];
        
        self.refundBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth-56 * widthFloat -14, 45, 56 * widthFloat, 30 * heightFloat) title:@"退票" titleColor:[UIColor whiteColor] cornerRadius:4.0f font:[UIFont systemFontOfSize:15 * widthFloat] backgroundColor:Color(0, 151, 235, 1.0) target:self action:@selector(noTicketClick:) tag:100];
        [view addSubview:self.refundBtn];
        
        //订单时间
        self.creatTimeLabel = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, 10, 10) text:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentRight];
        [view addSubview:self.creatTimeLabel];
        
    }
    return self;
}

- (void)noTicketClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(gotoRefundEventIndexPath:)]) {
        [self.delegate gotoRefundEventIndexPath:self.indexPath];
    }
}

- (void)configCellWithModel:(Order *)order
{
    [self.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,order.cover]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    CGSize nameSize = [FanShuToolClass createString:order.name font:[UIFont systemFontOfSize:17 * widthFloat] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth, 40)];
    if ([order.orderform_type intValue] == 1) {
        self.nameLb.frame = CGRectMake(90, 10, 200, 40);
    }else{
        self.nameLb.frame = CGRectMake(90, 10, nameSize.width, 40);
    }
    self.nameLb.text = order.name;
    
    
    
    if ([order.orderform_type intValue] == 1) {  //电影
        NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval interval =[order.time doubleValue] - currentInterval;
        int i = (int)interval / 3600;
        if (order.time) {
            if (i == 0) {
                //HH:mm:ss
                self.timeLb.text = [NSString stringWithFormat:@"距开场%d分钟",(int)interval / 60];
            }else if (i / 24 == 0){
                self.timeLb.text = [NSString stringWithFormat:@"距开场%d小时%d分钟",(int)interval / 3600,((int)interval % 3600) / 60];
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"距开场%d天%d小时%d分钟",(int)interval / 86400,((int)interval % 86400) / 3600, (((int)interval % 86400) % 3600) / 60];
            }
        }else{
            self.timeLb.text = @"";
        }
        CGSize timeSize = [self.timeLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * widthFloat]}];
        self.nameLb.frame = CGRectMake(90, 10, nameSize.width > (ScreenWidth -100 -timeSize.width -14) ? (ScreenWidth -100 -timeSize.width -14) : nameSize.width, 40);
        
        self.timeLb.frame = CGRectMake(100+self.nameLb.frame.size.width, 10, timeSize.width, 40);
        
        self.nameLb.text = order.name;
        self.descriptionLb.text = [NSString stringWithFormat:@"%@ %@",order.cinema_name,order.hall_name];
        self.priceLb.text = [NSString stringWithFormat:@"价格：%@元",order.price];
        [self.refundBtn setTitle:@"退票" forState:UIControlStateNormal];
        self.refundBtn.hidden = NO;
        self.refundBtn.backgroundColor = Color(0, 151, 235, 1.0);
        self.timeLb.hidden = NO;
    }else if ([order.orderform_type intValue] == 2){  //卖品
        self.timeLb.hidden = YES;
//        self.nameLb.text = @"观影套餐";
        self.descriptionLb.text = [NSString stringWithFormat:@"数量：%ld份",(long)order.number];

        self.nameLb.frame = CGRectMake(90, 10, 200, 40);
//        self.descriptionLb.text = order.detail;
        self.priceLb.text = [NSString stringWithFormat:@"价格：%@元",order.price];
        [self.refundBtn setTitle:@"退货" forState:UIControlStateNormal];
        self.refundBtn.hidden = YES;
        self.refundBtn.backgroundColor = Color(252, 186, 0, 1.0);
    }else{  //积分商品
        self.timeLb.hidden = YES;
        
        if ([order.score_type intValue] == 1) {  //积分商品-电影
            self.timeLb.hidden = NO;
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval interval =[order.time doubleValue] - currentInterval;
            int i = (int)interval / 3600;
            if (order.time) {
                if (i == 0) {
                    //HH:mm:ss
                    self.timeLb.text = [NSString stringWithFormat:@"距开场%d分钟",(int)interval / 60];
                }else if (i / 24 == 0){
                    self.timeLb.text = [NSString stringWithFormat:@"距开场%d小时%d分钟",(int)interval / 3600,((int)interval % 3600) / 60];
                }else{
                    self.timeLb.text = [NSString stringWithFormat:@"距开场%d天%d小时%d分钟",(int)interval / 86400,((int)interval % 86400) / 3600, (((int)interval % 86400) % 3600) / 60];
                }
            }else{
                self.timeLb.text = @"";
            }
            CGSize timeSize = [self.timeLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * widthFloat]}];
            self.nameLb.frame = CGRectMake(90, 10, nameSize.width > (ScreenWidth -100 -timeSize.width -14) ? (ScreenWidth -100 -timeSize.width -14) : nameSize.width, 40);
            
            self.timeLb.frame = CGRectMake(100+self.nameLb.frame.size.width, 10, timeSize.width, 40);
            
            self.nameLb.text = order.name;
            self.descriptionLb.text = [NSString stringWithFormat:@"%@ %@",order.cinema_name,order.hall_name];
            self.refundBtn.hidden = YES;
            self.priceLb.text = [NSString stringWithFormat:@"价格：%@积分",order.score];
        }else if ([order.score_type intValue] == 2){ //积分商品-纪念品
//            self.nameLb.text = @"纪念品";
            self.descriptionLb.text = [NSString stringWithFormat:@"数量：%ld份",(long)order.number];

//            self.descriptionLb.text = order.name;
            self.refundBtn.hidden = YES;
            self.priceLb.text = [NSString stringWithFormat:@"价格：%@积分",order.score];
        }else{ //积分商品-观影套餐
//            self.nameLb.text = @"观影套餐";
            self.descriptionLb.text = [NSString stringWithFormat:@"数量：%ld份",(long)order.number];

            self.nameLb.frame = CGRectMake(90, 10, 200, 40);
//            self.descriptionLb.text = order.name;
            self.refundBtn.hidden = YES;
            self.priceLb.text = [NSString stringWithFormat:@"价格：%@积分",order.score];
        }
    }
    
    //订单时间
    if (order.create_time > 10) {
        self.creatTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.priceLb.frame), self.priceLb.y, ScreenWidth - self.priceLb.x - self.priceLb.width - 10, self.priceLb.height);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:order.create_time];
        NSString *dateStr = [[WXCalender shareCalender] dateStrWithDate:date dateStrFormatterStr:@"yyyy-MM-dd HH:mm"];
        self.creatTimeLabel.text = dateStr;
    } else {
        self.creatTimeLabel.frame = CGRectZero;
    }
}
@end
