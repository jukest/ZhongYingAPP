//
//  LFSPopupView.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LFSPopupBlock)(int);

@interface LFSPopupView : UIControl<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_popupTitle;// 弹窗标题
    LFSPopupBlock _LFSBlock;
    NSArray *_popupArr;// 弹窗数据源
    LFSPopupStatus _popupStatus;// 数据格式
}
@property (nonatomic,strong) UITableView *tableView;

- (void)createTableViewWithArr:(NSArray *)popupArr withTitle:(NSString *)title withBackColor:(UIColor *)color withType:(LFSPopupStatus)type withLFSBlock:(LFSPopupBlock)LFSBlock;

@end
