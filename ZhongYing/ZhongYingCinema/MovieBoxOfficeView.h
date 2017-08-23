//
//  MovieBoxOfficeView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieBoxOfficeView : UIView

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *todayLb;
@property(nonatomic,strong) UILabel *historyLb;
@property(nonatomic,strong) UILabel *rankLb;

- (void)configMovieBoxOfficeViewWithDictionary:(NSDictionary *)box_office;

@end
