//
//  ZFSeatSelectionView.h
//  ZFSeatSelection
//
//  Created by qq 316917975  on 16/7/9.
//
//

#import <UIKit/UIKit.h>
#import "ZFSeatsView.h"
#import "ZFIndicatorView.h"

@interface ZFSeatSelectionView : UIView

/**按钮父控件*/
@property (nonatomic, weak) ZFSeatsView *seatView;
/**指示框*/
@property (nonatomic, weak) ZFIndicatorView *indicator;
/**按钮数组*/
@property (nonatomic, strong) NSMutableArray *seatBtns;
/**seatScrollView*/
@property (nonatomic, weak) UIScrollView *seatScrollView;

/**frame 初始化必需设置你的frame  seatsArray座位数组    hallName影厅名称   actionBlock按钮点击回调－>传回就是选中的按钮数组*/

-(instancetype)initWithFrame:(CGRect)frame SeatsArray:(NSMutableArray *)seatsArray HallName:(NSString *)hallName seatBtnActionBlock:(void(^)(id x))actionBlock;

- (CGRect)_zoomRectInView:(UIView *)view forScale:(CGFloat)scale withCenter:(CGPoint)center;

@end
