//
//  WXSegmentView.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/19.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^titleChooseBlock)(NSInteger x);
typedef NS_ENUM(NSInteger, WXSegmentStyle) {
    /**
     * By default, there is a slider on the bottom.
     */
    WXSegmentStyleSlider = 0,
    /**
     * This flag will zoom the selected text label.
     */
    WXSegmentStyleZoom   = 1,
};

@interface WXSegmentView : UIView

@property (nonatomic, copy) titleChooseBlock titleChooseReturn;
/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray withStyle:(WXSegmentStyle)style;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param titleColor The normal title color.
 * @param selectedColor The selected title color.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(WXSegmentStyle)style;


@end
