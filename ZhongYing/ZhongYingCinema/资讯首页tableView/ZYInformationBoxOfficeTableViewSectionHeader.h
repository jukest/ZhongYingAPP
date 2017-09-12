//
//  ZYInformationBoxOfficeTableViewSectionHeader.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYInformationBoxOfficeTableViewSectionHeader;
@protocol ZYInformationBoxOfficeTableViewSectionHeaderDelegate <NSObject>

@optional
- (void)informationBoxOfficeTableViewSectionHeader:(ZYInformationBoxOfficeTableViewSectionHeader *)sectionHeaderView buttonDidClick:(UIButton *)button;

@end

@interface ZYInformationBoxOfficeTableViewSectionHeader : UIView
/** 票房排名分类数组 */
@property (nonatomic, strong) NSArray *boxOfficeCategoryTitles;

@property (nonatomic, weak) id <ZYInformationBoxOfficeTableViewSectionHeaderDelegate> delegate;

@end
