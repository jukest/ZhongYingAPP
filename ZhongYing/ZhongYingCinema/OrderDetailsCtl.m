//
//  OrderDetailsCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/12/2.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "OrderDetailsCtl.h"
#import "OrderDetails.h"

@interface OrderDetailsCtl ()
{
    UIScrollView *_scrollView;
    UIView *_whiteView;
    NSArray *_arr;
    NSArray *_contents;
    MBProgressHUD *_HUD;
    OrderDetails *_details;
}
@end

@implementation OrderDetailsCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"订单详情";
    
    _scrollView = [UIViewController createScrollView];
    [self.view addSubview:_scrollView];
    
    
//    if ([self.order.orderform_type integerValue] == 1 || ([self.order.orderform_type integerValue] == 3 && [self.order.score_type integerValue] == 1)) { // 电影
//        _arr = @[@"影片：",@"影院：",@"场次：",@"座位："];
//        //_contents = @[@"中影UL城市影院(乐尚店)",@"小黄人公仔1个"];
//    }else if ([self.order.orderform_type integerValue] == 2){ // 卖品
//        _arr = @[@"影院：",@"食品："];
//        //_contents = @[@"中影UL城市影院(乐尚店)",@"小爆米花1份+小可乐1杯"];
//    }else{ // 积分商城
//        _arr = @[@"影院：",@"商品："];
//        //_contents = @[@"机械师2：复活",@"中影UL城市影院(乐尚店)",@"2016-7-18（周一）16：30",@"3号厅  6排6座"];
//    }
    
    
    
    [self loadOrderDetail];
}

- (void)createOrderDetailsUI{
    
    _whiteView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 50 * heightFloat * _arr.count) backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_whiteView];
    
    for (int i=0; i<_arr.count; i++) {
        CGSize leftSize = [FanShuToolClass createString:_arr[i] font:[UIFont systemFontOfSize:17 * widthFloat] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth, 50)];
        UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 50 * heightFloat *i, leftSize.width, 50 * heightFloat -1) text:_arr[i] font:[UIFont systemFontOfSize:17 * widthFloat] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentLeft];
        [_whiteView addSubview:leftLb];
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(20, 50 * heightFloat -1 + 50 * heightFloat * i, ScreenWidth -40, 1) backgroundColor:Color(243, 243, 243, 1.0)];
        [_whiteView addSubview:line];
        if (i > 3) {
            UILabel *rightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20+leftSize.width, 50 * heightFloat*i, ScreenWidth-40-leftSize.width, 50 * heightFloat -1) text:_contents[i] font:[UIFont systemFontOfSize:15 * widthFloat] textColor:[UIColor redColor] alignment:NSTextAlignmentRight];
            rightLb.numberOfLines = 0;
            [_whiteView addSubview:rightLb];

        } else {
            
            UILabel *rightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20+leftSize.width, 50 * heightFloat*i, ScreenWidth-40-leftSize.width, 50 * heightFloat -1) text:_contents[i] font:[UIFont systemFontOfSize:15 * widthFloat] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentRight];
            rightLb.numberOfLines = 0;
            [_whiteView addSubview:rightLb];
        }
    }
    //392 256
    UIImageView *codeImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 280 * widthFloat, 280 * widthFloat) image:nil tag:100];
    codeImg.center = CGPointMake(ScreenWidth / 2, 50 * heightFloat * _arr.count +80 +250 * widthFloat / 2);
    [codeImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageDetail_URL,_details.qrcode]] placeholderImage:[UIImage imageNamed:@""]];
    [_scrollView addSubview:codeImg];
    
    NSMutableString *orderNum = [[NSMutableString alloc] initWithString:_details.order_sn];
    
    UILabel *orderNumLb = [FanShuToolClass createLabelWithFrame:CGRectMake(codeImg.frame.origin.x, 50 * heightFloat * _arr.count +80 -12 -20, ScreenWidth, 20) text:[NSString stringWithFormat:@"取货码：%@",_details.ticket_code] font:[UIFont systemFontOfSize:16 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    orderNumLb.center = CGPointMake(ScreenWidth / 2, 50 * heightFloat * _arr.count +80 -12 -20 +10);
    [_scrollView addSubview:orderNumLb];
    
    UILabel *getCodeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, ScreenWidth, 20) text:[NSString stringWithFormat:@"订单号：%@",orderNum] font:[UIFont systemFontOfSize:16 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    getCodeLb.center = CGPointMake(ScreenWidth / 2, 50 * heightFloat * _arr.count +80 -12 -20 -12 -10);
    [_scrollView addSubview:getCodeLb];
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(codeImg.frame));
}

- (void)loadOrderDetail
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserOrderformDetailURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    
    parameters[@"orderform_id"] = self.order.orderform_id;
    
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getOrderformDetail%@",dataBack);
        if ([dataBack[@"code"] integerValue] == 0) {
            NSDictionary *info = dataBack[@"content"][@"info"];
            NSError *error;
            OrderDetails *details = [OrderDetails mj_objectWithKeyValues:info];
            _details = details;
            if (error) {
                NSLog(@"orderDetails_error=%@",error);
            }
           
            if ([self.order.orderform_type integerValue] == 1 || ([self.order.orderform_type integerValue] == 3 && [self.order.score_type integerValue] == 1)) { // 电影
                NSString *dateStr = [details.time transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"];
                NSString *weakStr = [NSString getWeekDayFordate:[details.time doubleValue]];
                NSString *timeStr = [details.time transforTomyyyyMMddWithFormatter:@"HH:mm"];
                NSString *str = [NSString stringWithFormat:@"%@（%@）%@",dateStr,weakStr,timeStr];
                NSString *hallStr = details.hall_name;
                NSMutableArray *seatArr = [NSMutableArray array];
                for (NSDictionary *seat in details.seat) {
                    NSString *string = [NSString stringWithFormat:@"%@排%@座",seat[@"row"],seat[@"column"]];
                    [seatArr addObject:string];
                }
                NSString *seatStr = [seatArr componentsJoinedByString:@" "];
                if (details.coupon_price > 0.001 ) {//有优惠券
                    _contents = @[details.name,details.cinema_name,str,[NSString stringWithFormat:@"%@ %@",hallStr,seatStr],[NSString stringWithFormat:@"￥%.2f",details.total_price],[NSString stringWithFormat:@"-￥%.2f",details.coupon_price],[NSString stringWithFormat:@"￥%.2f",details.true_price]];
                    _arr = @[@"影片：",@"影院：",@"场次：",@"座位：",@"原价：",@"优惠减免：",@"实付："];
                } else { //没有优惠券
                    
                    _contents = @[details.name,details.cinema_name,str,[NSString stringWithFormat:@"%@ %@",hallStr,seatStr],[NSString stringWithFormat:@"￥%.2f",details.total_price]];
                    _arr = @[@"影片：",@"影院：",@"场次：",@"座位：",@"总价："];
                    
                }

            }else if ([self.order.orderform_type integerValue] == 2){ // 卖品
                _contents = @[details.cinema_name,details.name];
            }else{ // 积分商城
                _contents = @[details.cinema_name,details.name];
            }
            
            [self createOrderDetailsUI];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
