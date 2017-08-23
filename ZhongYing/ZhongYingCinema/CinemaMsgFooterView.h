//
//  CinemaMsgFooterView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,CinemaMsgFooterViewEvents){
    CinemaMsgConcernEvent = 700,
    CinemaMsgCommentEvent,
};
@protocol CinemaMsgFooterViewDelegate <NSObject>

- (void)jumpToCinemaMsgFooterViewEvents:(CinemaMsgFooterViewEvents)event;

@end
@interface CinemaMsgFooterView : UIView

@property(nonatomic,strong) UIButton *concernBtn;
@property(nonatomic,strong) UIButton *commentBtn;
@property(nonatomic,weak) id<CinemaMsgFooterViewDelegate> delegate;

- (void)configViewWithIs_star:(BOOL)is_star;

@end
