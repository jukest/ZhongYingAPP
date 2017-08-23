//
//  InfoDetailsShareView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InfoDeatilsShareViewEvents){
    WeChatFriendsShare = 1000,
    WeChatFriendsCircleShare,
    QQFriendsShare,
    QzoneShare,
    SinaShare,
};

@protocol InfoDetailsShareViewDelegate <NSObject>

- (void)jumpToShareView:(InfoDeatilsShareViewEvents)events;

@end
@interface InfoDetailsShareView : UIView

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UIButton *WFriendShareBtn;
@property(nonatomic,strong) UIButton *friendCircelShareBtn;
@property(nonatomic,strong) UIButton *QFriendShareBtn;
@property(nonatomic,strong) UIButton *QzoneShareBtn;
@property(nonatomic,strong) UIButton *sinaShareBtn;
@property(nonatomic,weak) id<InfoDetailsShareViewDelegate> delegate;

- (void)show;

- (void)hiddenView;

@end
