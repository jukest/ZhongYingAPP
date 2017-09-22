//
//  WXSegmentView.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/19.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "WXSegmentView.h"
#import "WXSegmentViewCell.h"

@interface WXSegmentView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _HeaderH;
    UIColor *_titleColor;
    UIColor *_titleSelectedColor;
    WXSegmentStyle _SegmentStyle;
    CGFloat _titleFont;
}
/**
 *  The bottom red slider.
 */
@property (nonatomic, weak) UIView *slider;

@property (nonatomic, strong) NSMutableArray *titlesArray;

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) WXSegmentViewCell *lastSelectedCell;
@end

@implementation WXSegmentView


#pragma mark - delayLoading

- (UICollectionView *)collectionView {
    if (!_collectionView) {
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.frame = CGRectMake(0, 0, self.width, 40);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[WXSegmentViewCell class] forCellWithReuseIdentifier:@"WXSegmentViewCell"];
        [self addSubview:_collectionView];

    }
    return _collectionView;
}

- (NSMutableArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}




#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        
        _HeaderH = frame.size.height;
        _SegmentStyle = WXSegmentStyleSlider;
        _titleColor = [UIColor darkTextColor];
        _titleSelectedColor = Color(199, 13, 23, 1);
        _titleFont = 15;
    }
    return self;
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    [self setTitleArray:titleArray withStyle:0];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray withStyle:(WXSegmentStyle)style {
    [self setTitleArray:titleArray titleFont:0 titleColor:nil titleSelectedColor:nil withStyle:style];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(WXSegmentStyle)style {
    
    //    set style
    if (style != 0) {
        _SegmentStyle = style;
    }
    if (font != 0) {
        _titleFont = font;
    }
    if (titleColor) {
        _titleColor = titleColor;
    }
    if (selectedColor) {
        _titleSelectedColor = selectedColor;
    }
    [self.titlesArray removeAllObjects];
    self.titlesArray = [titleArray mutableCopy];
    
    [self.collectionView reloadData];
    
    if (self.titlesArray.count == 0) {
        return;
    }
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titlesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WXSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WXSegmentViewCell" forIndexPath:indexPath];
    
    cell.label.text = self.titlesArray[indexPath.row];
    cell.selectedLabel.text = self.titlesArray[indexPath.row];
    
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10 ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10 ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(100 , 40);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat top = 0;
    CGFloat bottom = 0;
    
    return UIEdgeInsetsMake(top, 10, bottom, 10);
    
}

#pragma mark --UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.titleChooseReturn) {//回调
        self.titleChooseReturn(indexPath.row);
    }
}


@end
