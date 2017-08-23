//
//  CinemaTableViewCell.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/24.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotFilm.h"

typedef NS_ENUM(NSInteger,CinemaTableViewCellEvents){
    CinemaTableViewCellBuyEvents = 300,
    CinemaTableViewCellPreSaleEvents,
    CinemaTableViewCellPlayEvents,
};

@protocol CinemaTableViewCellDelegate <NSObject>

- (void)gotoCinemaTableViewCellEvents:(CinemaTableViewCellEvents)event indexPath:(NSIndexPath *)indexPath;

@end
@interface CinemaTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *movieImg; //!< 电影海报
@property(nonatomic,strong) UILabel *nameLb;  //!< 电影名
@property(nonatomic,strong) UIButton *is3DImg;  //!< 3D
@property(nonatomic,strong) UIButton *hotImg;  //!< 电影热度
@property(nonatomic,strong) UIImageView *markImg;  //!< 电影评分图
@property(nonatomic,strong) UILabel *markLb;  //!< 电影评分数
@property(nonatomic,strong) UILabel *descriptionLb;  //!< 电影描述
@property(nonatomic,strong) UILabel *firstType;  //!< 类型1
@property(nonatomic,strong) UILabel *secType;  //!< 类型2
@property(nonatomic,strong) UILabel *thirdType;  //!< 类型3
@property(nonatomic,strong) UIButton *buyBtn;  //!< 购买
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,weak) id<CinemaTableViewCellDelegate> delegate;

- (void)configCellWithModel:(HotFilm *)hotFilm;

@end
