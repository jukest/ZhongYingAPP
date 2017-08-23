//
//  CinemaComplaintView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/24.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CinemaComplaintViewDelegate <NSObject>

- (void)sendComplaint:(NSString *)complaint;

@end
@interface CinemaComplaintView : UIView

@property(nonatomic,strong) UITextView *complaintFld;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UILabel *noteLb;
@property(nonatomic,strong) UIButton *sendBtn;
@property(nonatomic,weak) id<CinemaComplaintViewDelegate> delegate;

- (void)show;
- (void)hiddenView;

@end
