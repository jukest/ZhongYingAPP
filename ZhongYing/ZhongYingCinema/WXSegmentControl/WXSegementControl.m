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


@property (nonatomic, strong)UIButton *selectBtn;

/**
 选中的背景颜色
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

/**
 未选中的背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundColor;


/**
 记录特殊的背景颜色的数组
 */
@property (nonatomic, strong) NSMutableArray <UIColor *> *backgroundColors;


/**
 记录特殊的被选中的背景颜色的数组
 */
@property (nonatomic, strong) NSMutableArray <UIColor *> *selectedBackgroundColors;

@end

@implementation WXSegementControl

- (NSMutableArray<UIColor *> *)backgroundColors {
    if (!_backgroundColors) {
        _backgroundColors = [NSMutableArray arrayWithCapacity:10];
    }
    return _backgroundColors;
}

- (NSMutableArray<UIColor *> *)selectedBackgroundColors {
    if (!_selectedBackgroundColors) {
        _selectedBackgroundColors = [NSMutableArray arrayWithCapacity:10];
    }
    return _selectedBackgroundColors;
}


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
        
        //添加 选择影院之后 的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataNotification:) name:SelectedCimemaUpdataMainCimemaDataNotification object:nil];
    }
    
    return self;
    
}

- (void)refreshDataNotification:(NSNotification *)notification {
    [self btnAction:self.buttons[0]];
}

- (void)setupUI {
    
    //创建按钮
    CGFloat btnW = self.frame.size.width / self.items.count;
    CGFloat btnH = self.frame.size.height;
    
    for (int i = 0; i < self.items.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
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
    
//    [self setSelectedBackgroundColor:self.selectedBackgroundColors[sender.tag] forIndex:sender.tag];
//    [self setBackgroundColor:self.backgroundColors[self.selectBtn.tag] forIndex:self.selectBtn.tag];
    
    
    
    
    self.selectBtn = sender;

    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(segementControlDidSelectIndex:)]) {
            [self.delegate segementControlDidSelectIndex:sender.tag];
        }
    }
    
    if (self.callBackBlock != nil) {
        self.callBackBlock(sender.tag);
    }
        
}

#pragma mark - 设置

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state forIndex:(NSInteger)index {

    
    for (int i = 0; i<self.buttons.count; i++) {
        
        
        if (i == index) {
            UIButton *button = self.buttons[i];
            [button setTitleColor:color forState:state];
        }
        
    }
    
}


- (void)setBackgroundColor:(UIColor *)color forIndex:(NSInteger)index {
    for (int i = 0; i < self.buttons.count; i++) {
        
        UIButton *btn = self.buttons[i];
        if (index == i) {
            
            if (self.backgroundColors.count != 0) {
                
                
                
            }
            
            if (self.backgroundColors[index]) {
                
                [self.backgroundColors insertObject:color atIndex:index];
            }
            btn.backgroundColor = color;
        }
        
    }
    
    
}

- (void)setSelectedBackgroundColor:(UIColor *)color forIndex:(NSInteger)index {
    
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];

        if (index == i) {
            
            if (self.selectedBackgroundColors[index]) {
                
                [self.selectedBackgroundColors insertObject:color atIndex:index];
            }
            
            
            btn.backgroundColor = color;
        }
    }
    
}


#pragma mark --重写set方法

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    _selectedBackgroundColor = selectedBackgroundColor;

}






@end
