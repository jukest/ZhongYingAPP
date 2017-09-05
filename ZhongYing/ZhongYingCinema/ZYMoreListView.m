//
//  ZYMoreListView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMoreListView.h"
#import "ZYButton.h"

@interface ZYMoreListView ()
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray <UIButton *> *btns;
@end

@implementation ZYMoreListView
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
    /**
    计算行号：int row = index / 3 ; 决定y
    计算列号：int col = index % 3；决定x
     */
    
    //计算总共有多少行
    NSInteger col = 3;
    NSInteger totalRow = self.titles.count / col == 0 ? self.titles.count : (self.titles.count / col + 1);
    
    CGFloat width = self.width / col;
    
    CGFloat height = 100 ;
    
    for (int i = 0; i < totalRow; i++) {//行
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i * height , self.width, height)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        if (i != totalRow - 1) {
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, view.height - 2, self.width, 2)];
            line.backgroundColor = Color(239, 239, 239, 1);
            [view addSubview:line];
        }
        
        
        for (int j = 0; j < col; j++) {//列
            
            if ((i * col + j) == self.titles.count) {
                break;
            }
            
            ZYButton *btn = [FanShuToolClass zy_createButtonWithFrame:CGRectMake(j * width, 0, width, view.height - 10) title:self.titles[i * col + j] titleColor:[UIColor blackColor] target:self action:@selector(btnClickAction:) tag:5+(i * col + j)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setImage:[UIImage imageNamed:self.imgs[i * col + j]] forState:UIControlStateNormal];
            //        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
            [view addSubview:btn];
            
            
            [self.btns addObject:btn];
            
            
        }
        
    }
    
    
    
}


- (void)btnClickAction:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(moreListView:buttonDidClick:)]) {
            [self.delegate moreListView:self buttonDidClick:sender];
        }
    }
}

@end
