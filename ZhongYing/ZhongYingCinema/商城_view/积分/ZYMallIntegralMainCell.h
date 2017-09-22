//
//  ZYMallIntegralMainCell.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYMallIntegralMainCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIsMain:(BOOL)isMain;
@end
