//
//  MyLoginView.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/22.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyLoginViewDelegate <NSObject>

- (void)MyLoginViewClickWithTag:(NSInteger)tag;

@end

@interface MyLoginView : UIView

@property (nonatomic,strong) UILabel *myLoginTitleLb;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,weak) id<MyLoginViewDelegate> delegate;

@end
