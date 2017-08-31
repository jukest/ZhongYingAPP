//
//  CustomCell.h
//  SimultaneousTest
//
//  Created by Leon.Hwa on 17/4/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray *datas;
@property (nonatomic, strong) UIViewController *VC;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withVC:(UIViewController *)VC;
@end
