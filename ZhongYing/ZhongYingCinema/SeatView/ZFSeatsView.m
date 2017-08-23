//
//  ZFSeatsView.m
//  ZFSeatSelection
//
//  Created by qq 316917975  on 16/7/9.
//
//

#import "ZFSeatsView.h"
#import "ZFSeatButton.h"
#import "ZFSeatSelectionConfig.h"
#import "ZFSeatSelectionView.h"
#import "UIImage+DrawText.h"

@interface ZFSeatsView ()

@property (nonatomic,copy) void (^actionBlock)(id);

@end

@implementation ZFSeatsView

-(instancetype)initWithSeatsArray:(NSMutableArray *)seatsArray maxNomarWidth:(CGFloat)maxW seatBtnActionBlock:(void (^)(id))actionBlock{
    
    if (self = [super init]) {
        
        self.actionBlock = actionBlock;
        
        ZFSeatsModel *seatsModel = seatsArray.firstObject;
        
        self.selectCount = 0;
        NSUInteger cloCount = [seatsModel.columns count];
        
        if (cloCount % 2) cloCount += 1;//偶数列数加1 防止中线压住座位
        
        CGFloat seatViewW = maxW - 2 * ZFseastsRowMargin;//整个座位视图的宽度
        
        CGFloat seatBtnW = seatViewW / cloCount;//座位按钮的宽度
        
        if (seatBtnW > ZFseastMinW_H) {
            seatBtnW = ZFseastMinW_H;
            seatViewW = cloCount * ZFseastMinW_H;
        }
        
        //初始化就回调算出按钮和自身的宽高
        CGFloat seatBtnH = seatBtnW;
        self.seatBtnWidth = seatBtnW;
        self.seatBtnHeight = seatBtnH;
        self.seatViewWidth = seatViewW;
        self.seatViewHeight = [seatsArray count] * seatBtnH;
        //初始化座位
        [self initSeatBtns:seatsArray];
        
    }
    return self;
}

-(void)initSeatBtns:(NSMutableArray *)seatsArray{
    
    [seatsArray enumerateObjectsUsingBlock:^(ZFSeatsModel *seatsModel, NSUInteger idx, BOOL *stop) {
        
        for (int i = 0; i < seatsModel.columns.count; i++) {
            
            ZFSeatModel *seatModel = seatsModel.columns[i];
            ZFSeatButton *seatBtn = [[ZFSeatButton alloc] init];
            seatBtn.seatmodel = seatModel;
            seatBtn.seatsmodel = seatsModel;
            
            if (![seatModel.type isEqualToString:@"road"]) {
                if ([seatModel.seatStatus isEqualToString:@"ok"]) {
                    [seatBtn setImage:[UIImage imageNamed:@"choosable"] forState:UIControlStateNormal];//这里更改座位图标
                    
//                    UIImage *image = [UIImage imageNamed:@"selected"];
//                    //                    NSInteger row = [seatBtn.seatmodel.rowValue integerValue];
//                    //                    NSInteger col = [seatBtn.seatmodel.columnValue integerValue];
//                    //                    image = [image imageWithTitle:[NSString stringWithFormat:@"%zd排\n%zd座",row,col] fontSize:5.5];
//                    [seatBtn setImage:image forState:UIControlStateSelected];
                    seatBtn.tag = [seatModel.cineSeatId integerValue];
                }else if ([seatModel.seatStatus isEqualToString:@"locked"] || [seatModel.seatStatus isEqualToString:@"booked"] || [seatModel.seatStatus isEqualToString:@"selled"] || [seatModel.seatStatus isEqualToString:@"repair"]){
                    [seatBtn setImage:[UIImage imageNamed:@"sold"] forState:UIControlStateNormal];
                    seatBtn.userInteractionEnabled = NO;
                }
            }else{
                continue;
            }
            [seatBtn addTarget:self action:@selector(seatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:seatBtn];
            
        }
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ZFSeatButton class]]) {
            ZFSeatButton *seatBtn = (ZFSeatButton *)view;
            NSInteger Col = [seatBtn.seatsmodel.columns indexOfObject:seatBtn.seatmodel];
            NSInteger Row = [seatBtn.seatsmodel.rowNum integerValue] - 1;
            seatBtn.frame = CGRectMake(Col * self.seatBtnHeight,Row * self.seatBtnHeight, self.seatBtnWidth, self.seatBtnHeight);
        }
    }
    
}

-(void)seatBtnAction:(ZFSeatButton *)seatbtn{
    if (seatbtn.selected || self.selectCount < 4) {
        seatbtn.selected = !seatbtn.selected;
        if (seatbtn.selected) {
            seatbtn.seatmodel.seatStatus = @"locked";//设置为选中
            
            // 选中时候设置绘制文字的背景图片
            UIImage *image = [UIImage imageNamed:@"selected"];
            NSInteger row = [seatbtn.seatmodel.rowValue integerValue];
            NSInteger col = [seatbtn.seatmodel.columnValue integerValue];
            image = [image imageWithTitle:[NSString stringWithFormat:@"%zd排\n%zd座",row,col] fontSize:5.5];
            [seatbtn setImage:image forState:UIControlStateSelected];
            
            self.selectCount ++;
        }else{
            seatbtn.seatmodel.seatStatus = @"ok";//设置为可选
            self.selectCount --;
        }
        if (self.actionBlock) self.actionBlock(seatbtn);
    }else{
        [self showMessage:@"每次最多可选4个座位"];
    }
}

- (void)showMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 8.f;
    hud.cornerRadius = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = 0 +self.superview.superview.frame.size.height / 2 -20;
    hud.labelFont = [UIFont systemFontOfSize:12];
    [hud hide:YES afterDelay:1.0f];
}


@end
