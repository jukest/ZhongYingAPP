//
//  WXSegementControl.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXSegementControlDelegate <NSObject>

@optional
- (void)segementControlDidSelectIndex:(NSInteger)index;

@end

@interface WXSegementControl : UIView
+(instancetype)segementControlWithFrame:(CGRect)frame withItems:(NSArray <NSString *>*)items;
-(instancetype)initWithFrame:(CGRect)frame withItems:(NSArray <NSString *>*)items;
@property (nonatomic, weak) id <WXSegementControlDelegate> delegate;
@end
