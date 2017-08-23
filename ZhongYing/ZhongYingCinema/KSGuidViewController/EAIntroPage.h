//
//  EAIntroPage.h
//  EAIntroView
//
//  Copyright (c) 2013 Evgeny Aleksandrov.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EAIntroPage : NSObject

@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain) UIImage *titleImage;
@property (nonatomic, assign) CGFloat imgPositionY;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titlePositionY;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) UIFont *descFont;
@property (nonatomic, retain) UIColor *descColor;
@property (nonatomic, assign) CGFloat descPositionY;
@property (nonatomic, retain) UIView *customView;

+ (EAIntroPage *)page;
+ (EAIntroPage *)pageWithCustomView:(UIView *)customV;

@end
