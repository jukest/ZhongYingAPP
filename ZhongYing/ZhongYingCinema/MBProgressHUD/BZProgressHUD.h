//
//  BZProgressHUD.h
//  BZSpecialtyStore
//
//  Created by wxman on 2016/12/3.
//  Copyright © 2016年 wxmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZProgressHUD : UIView

/** 菊花君(无文字)不自动隐藏 */
+ (void)showProgressToView:(UIView *)view;
/** 菊花君(无文字)带时间自动隐藏 */
+ (void)showProgressToView:(UIView *)view time:(NSTimeInterval)timeInterval;
/** 菊花君带文字自动隐藏时间 */
+ (void)showProgressToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInterval;
/** 菊花君带文字不自动隐藏时间 */
+ (void)showProgressToView:(UIView *)view text:(NSString *)text;

/** 纯文字不自动隐藏 */
+ (void)showToView:(UIView *)view text:(NSString *)text;
/** 纯文字自动隐藏 */
+ (void)showToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInterval;

/** 隐藏菊花君 */
+ (void)hiddenFromeView:(UIView *)view;

/** 显示成功的信息 */
+ (void)showSuccessToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInterval;
/** 显示错误的信息 */
+ (void)showErrorToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInderval;


@end
