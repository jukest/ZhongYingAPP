//
//  InfoCommentCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/8.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsComment.h"

@interface InfoCommentCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UILabel *commentLb;

- (void)configCellWithModel:(NewsComment *)comment;

@end
