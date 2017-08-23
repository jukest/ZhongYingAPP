//
//  ComplaintCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Complaint.h"

@interface ComplaintCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImg;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *complaintLb;
@property(nonatomic,strong) UIImageView *replyImg;
@property(nonatomic,strong) UILabel *replyLb;
@property(nonatomic,strong) UILabel *dateLb;

- (void)configCellWithModel:(Complaint *)Complaint;

@end
