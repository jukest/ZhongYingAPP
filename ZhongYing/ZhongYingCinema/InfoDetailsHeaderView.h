//
//  InfoDetailsHeaderView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoDetailsHeaderViewDelegate <NSObject>

- (void)getContentHeight:(CGFloat)height;

@end
@interface InfoDetailsHeaderView : UIView

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UILabel *pageviewsLb;
//@property(nonatomic,strong) UIImageView *movieImg;
//@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,weak) id<InfoDetailsHeaderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame details:(NSDictionary *)details;

- (void)configViewWithDetails:(NSDictionary *)details;

@end
