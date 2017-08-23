//
//  ZFSeatsModel.h
//  ZhongYingCinema
//
//  Created by dscvsd on 17/1/3.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface ZFSeatsModel : JSONModel

@property(nonatomic,strong) NSArray *columns;
@property(nonatomic,copy) NSString *rowId;
@property(nonatomic,copy) NSString *rowNum;

@end
