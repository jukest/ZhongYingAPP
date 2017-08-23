//
//  Complaint.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/14.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "JSONModel.h"

@interface Complaint : JSONModel

@property(nonatomic,copy) NSString *complaint; //!<< 投诉内容
@property(nonatomic,copy) NSString *complaint_created_time; //!<< 投诉时间
@property(nonatomic,copy) NSString *reply; //!<< 投诉回复内容
@property(nonatomic,copy) NSString *reply_created_time; //!<< 投诉回复时间

@end
