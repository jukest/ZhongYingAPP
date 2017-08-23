//
//  Message.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/20.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Message : JSONModel

@property(nonatomic,copy) NSString *id;  //!<<消息ID
@property(nonatomic,copy) NSString *title;  //!<<消息
@property(nonatomic,copy) NSString *content;  //!<<消息内容
@property(nonatomic,copy) NSString *theme;  //!<<消息类型
@property(nonatomic,copy) NSString *created_time;  //!<<消息创建时间

@end
