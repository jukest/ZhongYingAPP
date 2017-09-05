//
//  ZYMyUpListView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMyUpListView.h"
#import "ZYButton.h"

@interface ZYMyUpListView ()
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray <UIButton *> *btns;
@end

@implementation ZYMyUpListView

- (NSMutableArray<UIButton *> *)btns {
    if (!_btns) {
        _btns = [NSMutableArray arrayWithCapacity:10];
    }
    return _btns;
}
- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray <NSString *> *)imgs withTitles:(NSArray <NSString *> *)titles {
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.imgs = imgs;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    CGFloat width = self.width / self.titles.count - 2 * (self.titles.count - 1);
    
    
    for (int i = 0; i<self.titles.count; i++) {
        ZYButton *btn = [FanShuToolClass zy_createButtonWithFrame:CGRectMake(i * (width + 2), 0, width, self.height) title:self.titles[i] titleColor:[UIColor blackColor] target:self action:@selector(myViewClickAction:) tag:1 + i];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setImage:[UIImage imageNamed:self.imgs[i]] forState:UIControlStateNormal];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [self addSubview:btn];
        
        if (i == self.titles.count - 1) {
            
        } else {
            UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 4, 2, self.height - 8) backgroundColor:Color(236, 236, 236, 1.0)];
            [self addSubview:line];
            
        }
        [self.btns addObject:btn];

    }
}

- (void)myViewClickAction:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    
    if (self.delegate!=nil) {
        if ([self.delegate respondsToSelector:@selector(myUpListView:buttonDidClick:)]) {
            [self.delegate myUpListView:self buttonDidClick:sender];
        }
    }
    
}

@end
