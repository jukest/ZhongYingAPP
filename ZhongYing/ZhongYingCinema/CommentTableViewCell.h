//
//  CommentTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoComment.h"

@interface CommentTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImg;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *contentLb;

- (void)configCellWithModel:(InfoComment *)comment;

@end
