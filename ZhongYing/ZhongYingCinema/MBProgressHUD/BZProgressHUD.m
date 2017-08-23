//
//  BZProgressHUD.m
//  BZSpecialtyStore
//
//  Created by wxman on 2016/12/3.
//  Copyright © 2016年 wxmac. All rights reserved.
//

#import "BZProgressHUD.h"
#import "MBProgressHUD.h"

@implementation BZProgressHUD

+(void)showProgressToView:(UIView *)view {
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)hiddenFromeView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)showProgressToView:(UIView *)view time:(NSTimeInterval)timeInterval {
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenFromeView:view];
    });
}

+ (void)showToView:(UIView *)view text:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.textColor = [UIColor redColor];
    
}

+ (void)showToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInterval {
    [self showToView:view text:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenFromeView:view];
    });
}


+ (void)showSuccessToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInterval {

    [self setupProgressHudWithView:view text:text success:YES time:timeInterval];
}

+ (void)showErrorToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInderval {

    [self setupProgressHudWithView:view text:text success:NO time:timeInderval];

}

+ (void)setupProgressHudWithView:(UIView *)view text:(NSString *)text success:(BOOL)success time:(NSTimeInterval)timeInderval {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    if (success) {
        hud.label.text = @"✅";
    } else if (!success){
        hud.label.text = @"❌";
    }
    hud.label.textColor = [UIColor blackColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInderval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenFromeView:view];
    });

}

/** 菊花君带文字自动隐藏时间 */
+ (void)showProgressToView:(UIView *)view text:(NSString *)text time:(NSTimeInterval)timeInterval {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.label.textColor = [UIColor redColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenFromeView:view];
    });
}
/** 菊花君带文字不自动隐藏时间 */
+ (void)showProgressToView:(UIView *)view text:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.label.textColor = [UIColor redColor];
    
}





@end
