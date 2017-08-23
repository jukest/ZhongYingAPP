//
//  CinemaCollectionViewCell.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotFilm.h"


typedef NS_ENUM(NSInteger,CinemaConllectionViewCellEvents){
    CinemaConllectionViewCellBuyEvents = 300,
    CinemaConllectionViewCellPreSaleEvents,
    CinemaConllectionViewCellPlayEvents,
};

@protocol CinemaCollectionViewCellDelegate <NSObject>

- (void)gotoCinemaCollectionViewCellEvents:(CinemaConllectionViewCellEvents)event indexPath:(NSIndexPath *)indexPath;

@end


@interface CinemaCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) HotFilm *hotFilm;
@property(nonatomic, weak) id <CinemaCollectionViewCellDelegate> delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;

@end
