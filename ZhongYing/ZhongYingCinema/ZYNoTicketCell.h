//
//  ZYNoTicketCell.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@protocol ZYNoticketCellDelegate <NSObject>

- (void)gotoRefundEventIndexPath:(NSIndexPath *)index;

@end
@interface ZYNoTicketCell : UITableViewCell
@property(nonatomic,strong) UIImageView *movieImg; // 电影海报
@property(nonatomic,strong) UILabel *nameLb;  // 电影名
@property(nonatomic,strong) UILabel *descriptionLb;  // 电影描述
@property(nonatomic,strong) UILabel *priceLb;  // 电影价格
@property(nonatomic,strong) UILabel *timeLb;  // 电影时间
@property(nonatomic,strong) UIButton *refundBtn;  // 退票
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) UILabel *creatTimeLabel;//订单时间
@property(nonatomic,strong) id <ZYNoticketCellDelegate>delegate;

- (void)configCellWithModel:(Order *)order;


@end
