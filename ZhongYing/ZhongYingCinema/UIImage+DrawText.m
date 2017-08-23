//
//  UIImage+DrawText.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/17.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "UIImage+DrawText.h"

@implementation UIImage (DrawText)

- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize

{
    
    //画布大小
    
    CGSize size=CGSizeMake(self.size.width,self.size.height);
    
    //创建一个基于位图的上下文
    
    UIGraphicsBeginImageContextWithOptions(size,NO,5);//opaque:NO  scale:0.0
    
    
    
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    
    
    //文字居中显示在画布上
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    
    
    //计算文字所占的size,文字居中显示在画布上
    
    CGSize sizeText=[title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                     
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor whiteColor]}context:nil].size;
    
    CGFloat width = self.size.width;
    
    CGFloat height = self.size.height;
    
    
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    
    //绘制文字
    
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[ UIColor whiteColor],NSParagraphStyleAttributeName:paragraphStyle}];
    
    
    
    //返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end
