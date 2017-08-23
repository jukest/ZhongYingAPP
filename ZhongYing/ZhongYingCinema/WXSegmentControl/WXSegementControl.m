//
//  WXSegementControl.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "WXSegementControl.h"

@interface WXSegementControl()

@property (nonatomic, strong)NSArray <NSString *> *items;

@property (nonatomic, strong)NSMutableArray <UIButton *> *buttons;

@property (nonatomic, strong)UIButton *selectBtn;



@end

@implementation WXSegementControl

- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons  = [NSMutableArray arrayWithCapacity:5];
    }
    return _buttons;
}


+ (instancetype)segementControlWithFrame:(CGRect)frame withItems:(NSArray<NSString *> *)items {
    return [[self alloc]initWithFrame:frame withItems:items];
}


- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray<NSString *> *)items {
    
    
    if (self = [super initWithFrame:frame]) {
        self.items = items;
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        
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
        if (i ==0) {
            btn.backgroundColor = [UIColor colorWithWhite:255 alpha:0.5];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.selected = YES;
            self.selectBtn = btn;
        } else {
            btn.backgroundColor = Color(123, 116, 133, 0.4);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self addSubview:btn];
        [self.buttons addObject:btn];
        
    }
    
}

- (void)btnAction:(UIButton *)sender {
    
    
    if (self.selectBtn == sender) {
        return;
    }
    
    
    
    
    self.selectBtn.selected = NO;
    
    sender.selected = YES;
    
    
    
    
    if (sender.tag == 1) {
        sender.backgroundColor = Color(123, 116, 133, 1);
    } else {
        self.selectBtn.backgroundColor = Color(123, 116, 133, 0.4);

    }
    
    self.selectBtn = sender;

    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(segementControlDidSelectIndex:)]) {
            [self.delegate segementControlDidSelectIndex:sender.tag];
        }
    }
        
}



@end
