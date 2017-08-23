//
//  MyMessageCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MyMessageCell : UITableViewCell

@property(nonatomic,strong) UIImageView *messageImg;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UILabel *receiveTimeLb;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) UIView *selectView;

- (void)configCellWithModel:(Message *)message;

@end
