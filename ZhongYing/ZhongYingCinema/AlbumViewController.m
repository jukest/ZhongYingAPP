//
//  AlbumViewController.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/28.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "AlbumViewController.h"
#import "PictureView.h"
#import "UIImageView+WebCache.h"

@interface AlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"电影图片";
    self.AlbumCollectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UICollectionView *)AlbumCollectionView
{
    if (_AlbumCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _AlbumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
        _AlbumCollectionView.delegate = self;
        _AlbumCollectionView.dataSource = self;

        [_AlbumCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AlbumViewControllerCell"];
        [self.view addSubview:_AlbumCollectionView];
    }
    return _AlbumCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumViewControllerCell" forIndexPath:indexPath];
    UIImageView *image = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, (ScreenWidth -38) / 3, 132) image:nil tag:indexPath.row];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,_pictures[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.contentView addSubview:image];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PictureView *pictureView = [[PictureView alloc] initWithFrame:self.view.bounds WithUrlStr:_pictures[indexPath.row] Sliders:_pictures Index:indexPath.row];
    
    [pictureView show];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth -38) / 3, 132);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(14, 12, 0, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 25;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

@end
