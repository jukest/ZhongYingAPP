//
//  MovieMessageView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotFilm.h"
#import "Movie.h"

typedef NS_ENUM(NSInteger,MovieMessageViewEvents){
    MoreDescriptionEvent = 555,
    MovieCollectEvent,
    MovieCommentEvent,
    MovieMessageViewPlayEvents,
};
@protocol MovieMessageViewDelegate <NSObject>

- (void)jumpToMovieMessageViewEvent:(MovieMessageViewEvents)event;

@end
@interface MovieMessageView : UIView

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *foreNameLb;
@property(nonatomic,strong) UILabel *typeLb;
@property(nonatomic,strong) UILabel *addressLb;
@property(nonatomic,strong) UILabel *releaseTimeLb;

@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UIButton *moreBtn;;
@property(nonatomic,strong) UIButton *collectBtn;
@property(nonatomic,strong) UIButton *commentBtn;
@property(nonatomic,strong) UIButton *playBtn;

@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,weak) id<MovieMessageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame film:(HotFilm *)film type:(NSString *)type;

- (void)configMovieMessageViewWithModel:(Movie *)movie;

@end
