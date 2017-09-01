//
//  FilmCategoryTagView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "FilmCategoryTagView.h"

@interface FilmCategoryTagView ()

@property (nonatomic, strong)NSArray <NSString *> *items;

@property (nonatomic, strong) NSArray <NSString *> *images;

@property (nonatomic, strong)UIButton *selectBtn;

@property (nonatomic, strong)UIView *lineView;

@end


@implementation FilmCategoryTagView



- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:10];
    }
    return _buttons;
}

+ (instancetype)filmCategoryTagViewWithFrame:(CGRect)frame withItems:(NSArray<NSString *> *)items {
    return [[self alloc]initWithFrame:frame withItems:items];
}

-(instancetype)initWithFrame:(CGRect)frame withItems:(NSArray <NSString *>*)items withImages:(NSArray <NSString *>*)images {
    
    if (self = [super initWithFrame:frame]) {
        self.items = items;
        self.images = images;
        
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray<NSString *> *)items {
    
    
    if (self = [super initWithFrame:frame]) {
        self.items = items;
        
        
        [self setupUI];
    }
    
    return self;
    
}

- (void)setupUI {
    
    //创建按钮
    CGFloat btnW = self.frame.size.width / self.items.count;
    CGFloat btnH = self.frame.size.height;
    
    for (int i = 0; i < self.items.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.items[i] forState:UIControlStateNormal];
        
        if (self.images.count != 0) {
            [btn setImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        }
        
        btn.backgroundColor = [UIColor colorWithWhite:255 alpha:1];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (i == 0) {
            
            btn.selected = YES;
            self.selectBtn = btn;
            
        }
        
        [self addSubview:btn];
        [self.buttons addObject:btn];
        
    }
    
    
    //创建指示条
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 2, self.selectBtn.frame.size.width * 0.5, 2)];
    self.lineView.center = CGPointMake(self.selectBtn.frame.origin.x + self.selectBtn.frame.size.width * 0.5, self.lineView.frame.origin.y + 1);
    self.lineView.backgroundColor = [UIColor redColor];
    [self addSubview:self.lineView];
    
}

- (void)btnAction:(UIButton *)sender {
    
    self.selectBtn.selected = NO;
    
    sender.selected = YES;
    
    
    self.selectBtn = sender;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(self.selectBtn.frame.origin.x + self.selectBtn.frame.size.width * 0.5, self.lineView.frame.origin.y + 1);

    } completion:nil];
    
    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(filmCategoryTagViewDidSelectIndex:)]) {
            [self.delegate filmCategoryTagViewDidSelectIndex:sender.tag];
        }
    }
    
    if(self.selectRow){
        self.selectRow(sender.tag);
    }
    
}

- (void)LHTabViewDidScroll:(LHTabView *)tabView {

//    CGFloat offSetX = tabView.offset.x + 0.5;
//    
//    NSInteger index = offSetX / ScreenWidth;
//    
//    [self btnAction:self.buttons[index]];
    
    
}

- (void)LHTabViewDidEndDecelerating:(LHTabView *)tabView {
    CGFloat offSetX = tabView.offset.x ;
    
    NSInteger index = offSetX / ScreenWidth;
    
    [self btnAction:self.buttons[index]];

}


@end
