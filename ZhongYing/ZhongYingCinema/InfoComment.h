//
//  InfoComment.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/13.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface InfoComment : JSONModel

@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *created_time;

@end
