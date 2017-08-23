//
//  InfoTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface InfoTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImg;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UIButton *pageviewsBtn;
@property(nonatomic,strong) UIButton *commentsBtn;

- (void)configCellWithModel:(News *)news;

@end
