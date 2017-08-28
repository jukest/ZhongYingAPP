//
//  WXMoveBtn.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoveBtnDidClick)(void);

@interface WXMoveBtn : UIView
{
    CGPoint beginPoint;
    CGFloat rightMargin;
    CGFloat leftMargin;
    CGFloat topMargin;
    CGFloat bottomMargin;
    CGMutablePathRef pathRef;
}

@property(nonatomic, strong) MoveBtnDidClick btnDidClickBlock;

@end
