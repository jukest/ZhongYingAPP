//
//  FanShuToolClass.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/16.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class ZYButton;
@interface FanShuToolClass : NSObject

// UITableView
+ (UITableView *)createTableViewPlainWithFrame:(CGRect)rect style:(UITableViewStyle)style target:(id)target;
// 图片
+ (UIImageView *)createImageViewWithFrame:(CGRect)rect image:(UIImage *)image tag:(NSInteger)tag;
// 线条
+ (UIImageView *)createImageViewWithFrame:(CGRect)rect color:(UIColor *)color;
// 文本
+ (UILabel *)createLabelWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment;
// UIView
+ (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;
// UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action tag:(NSInteger)tag;

// UIButton
+ (ZYButton *)zy_createButtonWithFrame:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action tag:(NSInteger)tag;

+ (UIButton *)createButtonWithFrame:(CGRect)rect image:(UIImage *)image target:(id)target action:(SEL)action tag:(NSInteger)tag;
// 电影票按钮操作[退票、退货、预售...]
+ (UIButton *)createButtonWithFrame:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action tag:(NSInteger)tag;
// UIScrollView
+ (UIScrollView *)createScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)size target:(id)target;
// UITextField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame textColor:(UIColor *)color font:(UIFont *)font target:(id)target;
// 计算文字高度
+ (CGSize)createString:(NSString *)string font:(UIFont *)font lineSpacing:(NSInteger)space maxSize:(CGSize)size;
// 设置Label文本间距
+ (NSMutableAttributedString *)getAttributeStringWithContent:(NSString *)content withLineSpaceing:(CGFloat)LineSpaceing;
// 封装菊花控件
+ (MBProgressHUD *)createMBProgressHUDWithText:(NSString *)text target:(id)target;
+ (MBProgressHUD *)createGIFMBProgressHUDWithText:(NSString *)text target:(id)target;

@end
