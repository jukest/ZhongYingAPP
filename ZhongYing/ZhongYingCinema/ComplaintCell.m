//
//  ComplaintCell.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ComplaintCell.h"

@implementation ComplaintCell

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
        self.headImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12, 18, 42, 42) image:[UIImage imageNamed:@"user_img"] tag:100];
        self.headImg.layer.cornerRadius = 21;
        self.headImg.clipsToBounds = YES;
        [self.contentView addSubview:self.headImg];
        
        self.nameLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +42 +8, 20, 150, 15) text:@"Someone" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.nameLb];
        
        self.timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -20 -100, 20, 100, 13) text:@"2小时前" font:[UIFont systemFontOfSize:14] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.timeLb];
        
        self.complaintLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12 +42 +8, 20 +15 +15, ScreenWidth -12 -42 -8 -18, 17) text:@"人在伤心时，都有倾诉的欲望" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.complaintLb.numberOfLines = 0;
        [self.contentView addSubview:self.complaintLb];
        
        self.replyImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(12 +42 +8, 20 +15 +15 +self.complaintLb.frame.size.height +8, ScreenWidth -62 -15, 0) image:[UIImage imageNamed:@"Complaint_background"] tag:101];
        self.replyImg.layer.cornerRadius = 2.0;
        self.replyImg.clipsToBounds = YES;
        [self.contentView addSubview:self.replyImg];
        
        UILabel *lb = [FanShuToolClass createLabelWithFrame:CGRectMake(10, 22, 60, 16) text:@"回复:" font:[UIFont systemFontOfSize:16] textColor:Color(130, 130, 130, 1.0) alignment:NSTextAlignmentLeft];
        [self.replyImg addSubview:lb];
        
        self.replyLb = [FanShuToolClass createLabelWithFrame:CGRectMake(10, 22 +16 +12, ScreenWidth -62 -15 -20, 17) text:@"感谢您对中影泰德影院的支持，谢谢!" font:[UIFont systemFontOfSize:16] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentLeft];
        self.replyLb.numberOfLines = 0;
        [self.replyImg addSubview:self.replyLb];
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(self.replyImg.frame.size.width -10 -80, 22 +16 +12 +self.replyLb.frame.size.height +12, 80, 12) text:@"08-19" font:[UIFont systemFontOfSize:14] textColor:Color(100, 100, 100, 1.0) alignment:NSTextAlignmentRight];
        [self.replyImg addSubview:self.dateLb];
    }
    return self;
}

- (void)configCellWithModel:(Complaint *)Complaint
{
    NSString *complaint = Complaint.complaint;
    NSString *reply = Complaint.reply;
    CGSize complaintSize = [FanShuToolClass createString:complaint font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -12 -42 -8 -18, ScreenHeight)];
    CGSize replySize = [FanShuToolClass createString:reply font:[UIFont systemFontOfSize:16] lineSpacing:3 maxSize:CGSizeMake(ScreenWidth -62 -15 -20, ScreenHeight)];
    self.complaintLb.frame = CGRectMake(12 +42 +8, 20 +15 +15, complaintSize.width, complaintSize.height);
    self.complaintLb.attributedText = [FanShuToolClass getAttributeStringWithContent:complaint withLineSpaceing:3];
    
    if ([reply isEqualToString:@""]) {
        self.replyImg.frame = CGRectMake(12 +42 +8, 20 +15 +15 +self.complaintLb.frame.size.height +8, ScreenWidth -62 -15, 0);
    }else{
        self.replyImg.frame = CGRectMake(12 +42 +8, 20 +15 +15 +self.complaintLb.frame.size.height +8, ScreenWidth -62 -15, 88 +replySize.height);
        self.replyLb.frame = CGRectMake(10, 22 +16 +12, ScreenWidth -62 -15 -20, replySize.height);
        self.dateLb.frame = CGRectMake(self.replyImg.frame.size.width -5 -80, 22 +16 +12 +self.replyLb.frame.size.height +12, 80, 12);
        self.replyLb.attributedText = [FanShuToolClass getAttributeStringWithContent:reply withLineSpaceing:3];
    }
    [self.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,ApiavatarStr]] placeholderImage:[UIImage imageNamed:@"user_img"]];
    self.nameLb.text = ApiNickNameStr;
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval = currentInterval - [Complaint.reply_created_time doubleValue];
    self.dateLb.text = [UIViewController getTimeStrWithInterval:interval];

    self.timeLb.text = [Complaint.complaint_created_time transforTomyyyyMMddWithFormatter:@"MM-dd HH:mm"];
}


@end
