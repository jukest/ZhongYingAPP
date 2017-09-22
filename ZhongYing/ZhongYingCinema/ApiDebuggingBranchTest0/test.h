//
//  test.h
//  ZhongYingCinema
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface test : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *descriptionTitle;
- (instancetype)initWithTitle:(NSString *)title withDescriptionTitle:(NSString *)descriptionTitle;
@end
