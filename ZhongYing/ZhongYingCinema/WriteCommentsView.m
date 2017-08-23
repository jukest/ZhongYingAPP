//
//  WriteCommentsView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "WriteCommentsView.h"

@interface WriteCommentsView ()<UITextFieldDelegate>

@end

@implementation WriteCommentsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.writeCommentsTfd = [FanShuToolClass createTextFieldWithFrame:CGRectMake(10, 10, frame.size.width -30 -47, frame.size.height -20) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16] target:self];
        self.writeCommentsTfd.layer.borderWidth = 0.8f;
        self.writeCommentsTfd.layer.borderColor = Color(239, 239, 239, 1.0).CGColor;
        self.writeCommentsTfd.placeholder = @"写评论";
        self.writeCommentsTfd.layer.cornerRadius = 5;
        self.writeCommentsTfd.layer.masksToBounds = YES;
        self.writeCommentsTfd.returnKeyType = UIReturnKeyDone;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 38)];
        UIImageView *leftImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(10, 9, 25, 20) image:[UIImage imageNamed:@"commnets_edit"] tag:200];
        [leftView addSubview:leftImg];
        self.writeCommentsTfd.leftView = leftView;
        [self addSubview:self.writeCommentsTfd];
        
        [self.writeCommentsTfd addTarget:self action:@selector(gotoTextFieldValueChange:) forControlEvents:UIControlEventEditingChanged];

        self.sendCommentsBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(ScreenWidth -57, 10, 47, frame.size.height -20) title:@"发送" titleColor:[UIColor whiteColor] target:self action:@selector(WriteCommentsViewEvents:) tag:SendCommentsEvents];
        self.sendCommentsBtn.backgroundColor = Color(204, 204, 204, 1.0);
        self.sendCommentsBtn.enabled = NO;
        self.sendCommentsBtn.layer.cornerRadius = 5;
        self.sendCommentsBtn.layer.masksToBounds = YES;
        [self addSubview:self.sendCommentsBtn];
    }
    return self;
}

#pragma mark - view Handle
- (void)WriteCommentsViewEvents:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(sendComments:)]) {
        [self.delegate sendComments:self.writeCommentsTfd.text];
    }
} 

- (void)gotoTextFieldValueChange:(UITextField *)fld
{
    if ([fld.text length] >= 6) {
        self.sendCommentsBtn.enabled = YES;
        self.sendCommentsBtn.backgroundColor = Color(252, 186, 0, 1.0);
    }else{
        self.sendCommentsBtn.enabled = YES;
        self.sendCommentsBtn.backgroundColor = Color(204, 204, 204, 1.0);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.writeCommentsTfd resignFirstResponder];
    return YES;
}

@end
