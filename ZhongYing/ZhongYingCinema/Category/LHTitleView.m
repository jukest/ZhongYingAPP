//
//  LHTitleView.m
//  SimultaneousTest
//
//  Created by Leon.Hwa on 17/4/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "LHTitleView.h"

const CGFloat margin = 42;
const CGFloat titleWidth = 32;
@interface LHTitleView()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableDictionary *pointsDict;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGFloat lineTotalWidth;
@property (nonatomic, assign) CGFloat lineWidth;
@end

@implementation LHTitleView

- (instancetype)initWithTitles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        _titles = titles;
        
        
        CGFloat titleWidth = (ScreenWidth) / titles.count;

        for (int i = 0; i < titles.count; i++) {
           UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(i * titleWidth, 0,titleWidth, TitleViewHeight)];
            [self setupBtn:Btn index:i];
        }
        
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, TitleViewHeight-1, WIDTH, 1)];
        
        bottomBorder.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        [self addSubview:bottomBorder];
        
    }
    return self;
}

- (void)setupLeftBtn:(UIButton *)rightBtn index:(NSInteger)index{
    if(index < 0){
        return;
    }
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(rightBtn.x - margin -titleWidth , 0, titleWidth, TitleViewHeight)];
    [self setupBtn:leftBtn index:index];
    [self setupLeftBtn:leftBtn index:--index];
}
- (void)setupRightBtn:(UIButton *)leftBtn index:(NSInteger)index{
    if(index > self.titles.count - 1){
        return;
    }
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame) + margin, 0, titleWidth, TitleViewHeight)];
    [self setupBtn:rightBtn index:index];
    [self setupRightBtn:rightBtn index:++index];
}

- (void)setupBtn:(UIButton *)btn index:(NSInteger)index{

    [btn setTitle:self.titles[index] forState:UIControlStateNormal];
    [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor: [UIColor grayColor] forState:UIControlStateSelected];
    btn.tag = index;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];

    [self addSubview:btn];
}

- (void)btnClick:(UIButton *)btn{
    [self layoutLineWithIndex:btn.tag];
    if(self.selectRow){
        self.selectRow( btn.tag);
    }
}

- (void)LHTabViewDidScroll:(LHTabView *)tabView{
    CGFloat offsetX = tabView.offset.x;
    NSInteger index = offsetX/WIDTH;
    
    CGFloat zero =  [self.pointsDict[@(0)][@"start"] floatValue];
    
    CGFloat currentStart =  [self.pointsDict[@(index)][@"start"] floatValue];
    
    CGFloat currentEnd =  [self.pointsDict[@(index)][@"end"] floatValue];
    
    CGFloat nextStart =  [self.pointsDict[@(index+1)][@"start"] floatValue];
    CGFloat nextEnd =  [self.pointsDict[@(index+1)][@"end"] floatValue];
    CGFloat PhysicsDelta = offsetX - index * WIDTH;
    CGFloat end,start;
    CGFloat delta = nextEnd - currentEnd;
    if(PhysicsDelta <= WIDTH/2){
        delta = (PhysicsDelta/(WIDTH/2)) * delta;
        end = currentEnd + delta;
        self.lineLayer.strokeStart = (currentStart - zero)/self.lineTotalWidth;
        self.lineLayer.strokeEnd = (end - zero)/self.lineTotalWidth;
    }else{
        delta = nextStart - currentStart;
        PhysicsDelta = PhysicsDelta - WIDTH/2;
        delta = (PhysicsDelta/(WIDTH/2)) * delta;
        start = currentStart + delta;
        self.lineLayer.strokeStart = (start - zero)/self.lineTotalWidth;
        self.lineLayer.strokeEnd = (nextEnd - zero)/self.lineTotalWidth;
    }
}
- (void)LHTabViewDidEndDecelerating:(LHTabView *)tabView{
    CGFloat offsetX = tabView.offset.x;
    NSInteger index = offsetX/WIDTH;
   [self layoutLineWithIndex:index];
}
- (void)layoutLineWithIndex:(NSInteger)index{
    CGFloat zero =  [self.pointsDict[@(0)][@"start"] floatValue];
    CGFloat start =  [self.pointsDict[@(index)][@"start"] floatValue];
    CGFloat end =  [self.pointsDict[@(index)][@"end"] floatValue];
    self.lineLayer.strokeStart = (start - zero)/self.lineTotalWidth;
    self.lineLayer.strokeEnd = (end - zero)/self.lineTotalWidth;
   
}
@end
