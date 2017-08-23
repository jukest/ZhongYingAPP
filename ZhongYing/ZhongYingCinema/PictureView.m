//
//  PictureView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/2/16.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "PictureView.h"
#import "UIImageView+WebCache.h"

#import "JT3DScrollView.h"
#import "DDPhotoScrollView.h"

@interface PictureView ()<UIScrollViewDelegate>
{
    UIButton    *_maskView;
}
@property (nonatomic, strong) JT3DScrollView *imageScrollView;
@property (nonatomic, strong) UIPageControl *control;
@property(nonatomic,copy) NSString *urlStr;
@property(nonatomic,strong) NSMutableArray *sliders;
@property(nonatomic,assign) NSInteger index;

@end

@implementation PictureView

- (instancetype)initWithFrame:(CGRect)frame WithUrlStr:(NSString *)urlStr Sliders:(NSArray *)sliders  Index:(NSInteger)index
{
    if (self = [super initWithFrame:frame]) {
        self.urlStr = urlStr;
        [self.sliders addObjectsFromArray:sliders];
        self.index = index;
        for (int i = 0; i < sliders.count; i ++) {
            [self.sliders replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,sliders[i]]];
        }

        [self addSubview:self.imageScrollView];
        
        _maskView = [FanShuToolClass createButtonWithFrame:[UIScreen mainScreen].bounds title:nil titleColor:[UIColor blackColor] target:self action:@selector(hiddenView) tag:1000];
        _maskView.backgroundColor = [UIColor blackColor];
        
        _control = [[UIPageControl alloc] init];
        _control.numberOfPages = self.sliders.count;
        _control.currentPage = index;
        
    }
    return self;
}

- (void)show
{
    [self animationWithView:self duration:0.3];
    _maskView.alpha= 0;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.5;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    _control.center = CGPointMake(ScreenWidth / 2, ScreenHeight - 40);
    [[UIApplication sharedApplication].keyWindow addSubview:_control];
    
    self.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
}

- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}

#pragma mark - Loay Load
- (NSMutableArray *)sliders
{
    if (_sliders == nil) {
        _sliders = [NSMutableArray array];
    }
    return _sliders;
}

- (JT3DScrollView *)imageScrollView
{
    if (_imageScrollView == nil) {
        // 设置大ScrollView  40:适当提高下imageView的高度，否则上面显得太空洞
        _imageScrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _imageScrollView.contentSize = CGSizeMake(_sliders.count * ScreenWidth, ScreenHeight);
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.effect = JT3DScrollViewEffectNone; // 切换的动画效果,随机枚举中的1，2，3三种效果。
        [_imageScrollView loadPageIndex:self.index animated:YES];
        _imageScrollView.clipsToBounds = YES;
        _imageScrollView.delegate = self;
        
        // 设置小ScrollView（装载imageView的scrollView）
        for (int i = 0; i < _sliders.count; i++) {
            //DDPhotoDetailModel *detailModel = self.photoModel.photos[i];
            DDPhotoScrollView *photoScrollView = [[DDPhotoScrollView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight) urlString:self.sliders[i]];
            // singleTapBlock回调：让所有UI，除了图片，全部消失
            photoScrollView.singleTapBlock = ^{
                
                [self hiddenView];
                
            };
            [_imageScrollView addSubview:photoScrollView];
        }
    }
    return _imageScrollView;
}

#pragma mark - View Handle
- (void)hiddenView
{   [_maskView removeFromSuperview];
    [_control removeFromSuperview];
    [self removeFromSuperview];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UIView *view in _imageScrollView.subviews) {
        if ([view isKindOfClass:[DDPhotoScrollView class]]) {
            DDPhotoScrollView *photo = (DDPhotoScrollView *)view;
            if (photo.zoomScale != 1.0) {
                [photo setZoomScale:1.0 animated:YES]; //还原
            }
        }
    }
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    _control.currentPage = index;
}

@end
