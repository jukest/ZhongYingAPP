//
//  ZYOrderDetailsCell.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"


@interface ZYOrderDetailsCell : UITableViewCell

@property (nonatomic, strong)Order *order;
@property (nonatomic, assign) NSInteger type;
@end
