//
//  MovePictureSliderView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "MovePictureSliderView.h"
#import "SCAdView.h"

@interface MovePictureSliderView ()<SCAdViewDelegate>
@property(nonatomic,strong) UILabel *titleLb;
@property (nonatomic, strong) NSArray *pictureArray;
@end

@implementation MovePictureSliderView


- (SCAdView *)adView {
    
    if (_adView == nil) {
        
        _adView = [[SCAdView alloc] initWithBuilder:^(SCAdViewBuilder *builder) {
            builder.viewFrame = (CGRect){0,28,self.bounds.size.width,self.bounds.size.height-28};
            builder.infiniteCycle = 5;
            builder.adItemSize = (CGSize){self.bounds.size.width/2.0f,/**self.bounds.size.width/3.8f*/self.bounds.size.height-28};
            builder.minimumLineSpacing = 10;
            builder.secondaryItemMinAlpha = 0.4;
            builder.threeDimensionalScale = 0;
//            builder.itemCellNibName = @"SCAdDemoCollectionViewCell";
            builder.itemCellClassName = @"MovePictureSliderCell";
        }];
        _adView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.2];
        _adView.delegate = self;
    }
    
    
    return _adView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 8, 65, 20) text:@"影片图片" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLb];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *)picArr
{
    if (self = [self initWithFrame:frame]) {
        if (picArr.count == 0) {
            
        } else {
            self.pictureArray = picArr;
            [self addSubview:self.adView];
        }
        
        
//        self.scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 36, ScreenWidth, 100) contentSize:CGSizeMake(12 + 85 * count + 10 * (count -1) + 12 + more, 100) target:self];
//        self.scrollView.showsHorizontalScrollIndicator = NO;
//        [self addSubview:self.scrollView];
    }
    return self;
}


- (void)configMoviePicSliderViewWithSliders:(NSArray *)sliders
{
    if (sliders.count == 0) {
        return;
    } else {
        [self addSubview:self.adView];
    }
    
    [self.adView play];
    self.pictureArray = sliders;
    [self.adView reloadWithDataArray:sliders];
    
    [self.adView _playNextAd];
}


#pragma mark -delegate

-(void)sc_didClickAd:(NSString *)adModel{
    if ([self.delegate respondsToSelector:@selector(jumpToPictureClickEvent:)]) {
        NSInteger index = [self.pictureArray indexOfObject:adModel];
        [self.delegate jumpToPictureClickEvent:index];
    }
}

-(void)sc_scrollToIndex:(NSInteger)index{
}




@end
