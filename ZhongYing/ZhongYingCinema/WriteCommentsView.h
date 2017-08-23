//
//  WriteCommentsView.h
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,WriteCommentsEvents){
    SendCommentsEvents = 100,
};
@protocol WriteCommentsViewDelegate <NSObject>

- (void)sendComments:(NSString *)comments;

@end
@interface WriteCommentsView : UIView

@property(nonatomic,strong) UITextField *writeCommentsTfd;
@property(nonatomic,strong) UIButton *sendCommentsBtn;
@property(nonatomic,weak) id<WriteCommentsViewDelegate> delegate;

@end
