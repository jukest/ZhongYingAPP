//
//  WXMoveBtn.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "WXMoveBtn.h"

@interface WXMoveBtn ()
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *crossBtn;
@end

@implementation WXMoveBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setupUI {
    [self setBtn];
//    [self setLabel];
}

- (void)setLabel {
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width * 0.5 + 10 , -1, 20, 20)];
    _numberLabel.backgroundColor = Color(252, 186, 0, 1.0);
    _numberLabel.font = [UIFont systemFontOfSize:12];
    _numberLabel.center = CGPointMake(self.width, 0);
    _numberLabel.layer.cornerRadius = 20 * 0.5;
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.textColor = [UIColor redColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = @"99";
    [self addSubview:_numberLabel];
    
}

- (void)setBtn {
    _crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _crossBtn.backgroundColor = Color(252, 186, 0, 1.0);
    [_crossBtn setTitle:@"购买" forState:UIControlStateNormal];
    _crossBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_crossBtn];
    
    _crossBtn.frame = self.bounds;
    _crossBtn.layer.masksToBounds = YES;
    _crossBtn.layer.cornerRadius = 20;
    
    //    _crossBtn.center = self.view.center;
    [_crossBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    rightMargin = [UIScreen mainScreen].bounds.size.width-30;
    leftMargin = 30;
    bottomMargin = [UIScreen mainScreen].bounds.size.height- 30 - 64 - 49;
    topMargin = 30;
    
    pathRef=CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, leftMargin, topMargin);
    CGPathAddLineToPoint(pathRef, NULL, rightMargin, topMargin);
    CGPathAddLineToPoint(pathRef, NULL, rightMargin, bottomMargin);
    CGPathAddLineToPoint(pathRef, NULL, leftMargin, bottomMargin);
    CGPathAddLineToPoint(pathRef, NULL, leftMargin, topMargin);
    CGPathCloseSubpath(pathRef);
}


#pragma mark - 事件
- (void)btnAction:(UIButton*)sender{
    if (self.btnDidClickBlock != nil) {
        self.btnDidClickBlock();
    }
    
}

#pragma mark - 手势
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        beginPoint = [pan locationInView:self.superview];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        CGPoint nowPoint = [pan locationInView:self.superview];
        
        float offsetX = nowPoint.x - beginPoint.x;
        float offsetY = nowPoint.y - beginPoint.y;
        CGPoint centerPoint = CGPointMake(beginPoint.x + offsetX, beginPoint.y + offsetY);
        
        if (CGPathContainsPoint(pathRef, NULL, centerPoint, NO))
        {
            self.center = centerPoint;
        }else{
            if (centerPoint.y>bottomMargin)
            {
                if (centerPoint.x<rightMargin&centerPoint.x>leftMargin) {
                    self.center = CGPointMake(beginPoint.x + offsetX, bottomMargin);
                }
            }
            else if (centerPoint.y<topMargin)
            {
                if (centerPoint.x<rightMargin&centerPoint.x>leftMargin) {
                    self.center = CGPointMake(beginPoint.x + offsetX, topMargin);
                }
            }
            else if (centerPoint.x>rightMargin)
            {
                self.center = CGPointMake(rightMargin, beginPoint.y + offsetY);
            }
            else if (centerPoint.x<leftMargin)
            {
                self.center = CGPointMake(leftMargin, beginPoint.y + offsetY);
            }
        }
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed){
    }
}


@end
