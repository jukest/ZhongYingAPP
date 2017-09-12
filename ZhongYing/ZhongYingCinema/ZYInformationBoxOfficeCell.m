//
//  ZYInformationBoxOfficeCell.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformationBoxOfficeCell.h"
#import "BoxOffice.h"


@interface ZYInformationBoxOfficeCell ()

/**
 影片名
 */
@property (nonatomic, strong) UILabel *filmNameLabel;

/** lable1 */
@property (nonatomic, strong) UILabel *label1;

/** lable2 */
@property (nonatomic, strong) UILabel *lable2;

/** lable3 */
@property (nonatomic, strong) UILabel *lable3;

/** lable4 */
@property (nonatomic, strong) UILabel *lable4;

/** label数组 */
@property (nonatomic, strong) NSMutableArray *labels;


@end

@implementation ZYInformationBoxOfficeCell

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray arrayWithCapacity:10];
    }
    return _labels;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    //电影名
    UILabel *filmName = [FanShuToolClass createLabelWithFrame:CGRectMake(ZYInformationBoxOfficeHeaderViewCellLeftLabelLeftMarge, 10, ZYInformationBoxOfficeHeaderViewCellLeftLabelWidth+20, self.height - 20) text:@"蜘蛛侠:英雄归来" font:[UIFont systemFontOfSize:13*heightFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [self addSubview:filmName];
    self.filmNameLabel = filmName;
    NSArray *data = @[@"1",@"2",@"3",@"4"];
    
    
    CGFloat x = ZYInformationBoxOfficeHeaderViewCellLeftLabelWidth + ZYInformationBoxOfficeHeaderViewCellLeftLabelLeftMarge;
    CGFloat w = (ScreenWidth - 2*ZYInformationBoxOfficeHeaderViewCellLeftLabelLeftMarge - ZYInformationBoxOfficeHeaderViewCellLeftLabelWidth) / data.count;
    for (int i = 0; i<data.count; i++) {
        UILabel *label = [FanShuToolClass createLabelWithFrame:CGRectMake(i * w + x , 10, w, self.height - 20) text:data[i] font:[UIFont systemFontOfSize:13*heightFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        [self addSubview:label];
        [self.labels addObject:label];
        
        
        switch (i) {
            case 0:
                self.label1 = label;
                break;
            case 1:
                self.lable2 = label;
                break;
            case 2:
                self.lable3 = label;
                break;
            default:
                self.lable4 = label;
                break;
        }
    }
}


- (void)setBoxOffice:(BoxOffice *)boxOffice {
    _boxOffice = boxOffice;
    
    self.filmNameLabel.text = boxOffice.name;
    self.label1.text = boxOffice.today_box_office;
    self.lable2.text = boxOffice.all_box_office;
    self.lable3.text = boxOffice.today_box_office;
    self.lable4.text = boxOffice.all_box_office;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
