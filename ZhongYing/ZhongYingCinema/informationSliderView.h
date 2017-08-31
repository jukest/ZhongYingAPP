//
//  informationSliderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

typedef NS_ENUM(NSInteger,InfoSliderViewEvents){
    NewsInfoEvent = 100,
    MovieInfoEvent,
    BoxOfficeEvnet,
};
@protocol infoSliderViewDelegate <NSObject>

@optional
- (void)infoSliderViewDelegateWithTag:(NSInteger)tag;

@end
@interface informationSliderView : UIView<SDCycleScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *imageArr;
@property(nonatomic,strong) SDCycleScrollView *adView;
//@property(nonatomic,strong) UIButton *newsInfoBtn;
//@property(nonatomic,strong) UIButton *movieInfoBtn;
//@property(nonatomic,strong) UIButton *boxOfficeBtn;
@property(nonatomic,weak) id<infoSliderViewDelegate> delegate;

- (void)configCellWithArray:(NSMutableArray *)picArr;

@end
