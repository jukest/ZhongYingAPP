//
//  FanShuToolClass.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/16.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "FanShuToolClass.h"
#import "UIImage+GIF.h"

@implementation FanShuToolClass

// UITableView
+ (UITableView *)createTableViewPlainWithFrame:(CGRect)rect style:(UITableViewStyle)style target:(id)target{
    UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:style];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = target;
    tableView.delegate = target;
    return tableView;
}

// UIImageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)rect image:(UIImage *)image tag:(NSInteger)tag{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect];
    imgView.userInteractionEnabled = YES;
    imgView.image = image;
    imgView.tag = tag;
    return imgView;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)rect color:(UIColor *)color{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect];
    imgView.userInteractionEnabled = YES;
    imgView.backgroundColor = color;
    return imgView;
}

// UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment{
    UILabel *lb = [[UILabel alloc]initWithFrame:rect];
    lb.text = text;
    lb.font = font;
    lb.textColor = color;
    lb.textAlignment = alignment;
    return lb;
}

// 有背景色的View
+ (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

// UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = rect;
    b.tag = tag;
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:color forState:UIControlStateNormal];
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return b;
}

+ (UIButton *)createButtonWithFrame:(CGRect)rect image:(UIImage *)image target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = rect;
    [b setImage:image forState:UIControlStateNormal];
    b.tag = tag;
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return b;
}

// 电影票按钮操作[退票、退货、预售...]
+ (UIButton *)createButtonWithFrame:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = rect;
    b.tag = tag;
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:color forState:UIControlStateNormal];
    b.layer.cornerRadius = cornerRadius;
    b.layer.masksToBounds = YES;
    b.titleLabel.font = font;
    b.backgroundColor = backgroundColor;
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return b;
}

// UIScrollView
+ (UIScrollView *)createScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)size target:(id)target{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.contentSize = size;
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = target;
    return scrollView;
}

// UITextField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame textColor:(UIColor *)color font:(UIFont *)font target:(id)target{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    // 设置TextField的内容垂直居中
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = color;
    textField.font = font;
    textField.leftViewMode = UITextFieldViewModeAlways;
    // 删除
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = target;
    return textField;
}

// 计算文字高度
+ (CGSize)createString:(NSString *)string font:(UIFont *)font lineSpacing:(NSInteger)space maxSize:(CGSize)size{
    if (System_Ver > 6.0) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = space;
        NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                              };
        return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }else{
        return [string sizeWithFont:font constrainedToSize:size];
    }
}

+ (NSMutableAttributedString *)getAttributeStringWithContent:(NSString *)content withLineSpaceing:(CGFloat)LineSpaceing
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:LineSpaceing];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    return str;
}

// 封装菊花控件
+ (MBProgressHUD *)createMBProgressHUDWithText:(NSString *)text target:(id)target{
    
    //登录操作
    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    HUD.delegate = target;
    HUD.label.text = text;
    [HUD showAnimated:YES];
    return HUD;
}

// 封装gif加载进度
+ (MBProgressHUD *)createGIFMBProgressHUDWithText:(NSString *)text target:(id)target
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    HUD.delegate = target;
    HUD.label.text = text;
    HUD.color = [UIColor clearColor];
    HUD.labelColor = [UIColor grayColor];
    HUD.labelFont = [UIFont systemFontOfSize:15];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 40, 40) image:[UIImage sd_animatedGIFNamed:@"load"] tag:100];
    [HUD show:YES];
    return HUD;
}

@end
