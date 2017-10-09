//
//  ZYOrderDetailsCtl.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYOrderDetailsCtl.h"
#import "ZYOrderDetailsCell.h"
#import "OrderDetails.h"
#import "Order.h"

@interface ZYOrderDetailsCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_HUD;
    NSArray *_arr;
}
@property (nonatomic, strong) OrderDetails *orderDetails;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *goods;

@end

@implementation ZYOrderDetailsCtl

#pragma mark -- 懒加载

- (NSMutableArray *)goods {
    if (!_goods) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerNib:[UINib nibWithNibName:@"ZYOrderDetailsCell" bundle:nil] forCellReuseIdentifier:@"orderDetailsCell"];
        [_tableView registerClass:[ZYOrderDetailsCell class] forCellReuseIdentifier:@"orderDetailsCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    
    [self loadOrderDetail];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYOrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailsCell" forIndexPath:indexPath];
    Order *order = self.goods[indexPath.row];
    cell.type = self.orderDetails.type;
    cell.order = order;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


- (UIView *)tableViewHeaderView{
    
    CGFloat height = 50;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,_arr.count * height)];
    
    for (int i = 0;i<_arr.count;i++) {
        
        CGSize leftSize = [FanShuToolClass createString:_arr[i] font:[UIFont systemFontOfSize:17 * widthFloat] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth, 30)];
        UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, i * height, leftSize.width, 50 * heightFloat -1) text:_arr[i] font:[UIFont systemFontOfSize:17 * widthFloat] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentLeft];
        [view addSubview:leftLb];
        
        if (i == 1) {
            UILabel *rightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(CGRectGetMaxX(leftLb.frame), i * height, ScreenWidth - CGRectGetMaxX(leftLb.frame)-10, 50 * heightFloat -1) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:[UIColor redColor] alignment:NSTextAlignmentRight];
            rightLb.numberOfLines = 0;
            if (self.orderDetails.type == 2) {
                
                rightLb.text = [NSString stringWithFormat:@"%.2f 积分",self.orderDetails.total_price ];
            } else  {
                rightLb.text = [NSString stringWithFormat:@"￥%.2f",self.orderDetails.total_price ];

            }
            [view addSubview:rightLb];


        } else if (i == 0) {
            UILabel *rightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(CGRectGetMaxX(leftLb.frame), i * height, ScreenWidth - CGRectGetMaxX(leftLb.frame)-10, 50 * heightFloat -1) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
            rightLb.numberOfLines = 0;
            rightLb.text = self.orderDetails.cinema_name;
            [view addSubview:rightLb];

        } else if (i == 2){
            UILabel *rightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(CGRectGetMaxX(leftLb.frame), i * height, ScreenWidth - CGRectGetMaxX(leftLb.frame)-10, 50 * heightFloat -1) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:[UIColor redColor] alignment:NSTextAlignmentRight];
            rightLb.numberOfLines = 0;
            rightLb.text = [NSString stringWithFormat:@"-￥%.2f",self.orderDetails.coupon_price];
            [view addSubview:rightLb];

        } else if (i == 3) {
            UILabel *rightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(CGRectGetMaxX(leftLb.frame), i * height, ScreenWidth - CGRectGetMaxX(leftLb.frame)-10, 50 * heightFloat -1) text:@"" font:[UIFont systemFontOfSize:15 * widthFloat] textColor:[UIColor redColor] alignment:NSTextAlignmentRight];
            rightLb.numberOfLines = 0;
            rightLb.text = [NSString stringWithFormat:@"￥%.2f",self.orderDetails.true_price];
            [view addSubview:rightLb];
        }
        
        
        
        
        
        UIView *line = [FanShuToolClass createViewWithFrame:CGRectMake(0, CGRectGetMaxY(leftLb.frame), ScreenWidth, 1) backgroundColor:Color(243, 243, 243, 1.0)];
        [view addSubview:line];
    }
    
    return view;
}

- (UIView *)tableViewFooterView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 350)];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView.backgroundColor = Color(241, 241, 241, 0.7);
    [view addSubview:lineView];
    
    NSMutableString *orderNum = [[NSMutableString alloc] initWithString:self.orderDetails.order_sn];
    
    UILabel *orderNumLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, 10, ScreenWidth-20, 20) text:[NSString stringWithFormat:@"取货码：%@",self.orderDetails.ticket_code] font:[UIFont systemFontOfSize:16 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [view addSubview:orderNumLb];
    
    UILabel *getCodeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(orderNumLb.frame)+10, ScreenWidth-20, 20) text:[NSString stringWithFormat:@"订单号：%@",orderNum] font:[UIFont systemFontOfSize:16 * widthFloat] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [view addSubview:getCodeLb];
    
    
    UIImageView *codeImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, CGRectGetMaxY(getCodeLb.frame) + 10, 280 * widthFloat, 280 * widthFloat) image:nil tag:100];
    [codeImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageDetail_URL,self.orderDetails.qrcode]] placeholderImage:[UIImage imageNamed:@""]];
    [view addSubview:codeImg];
    codeImg.center = CGPointMake(view.center.x, codeImg.center.y);
    
    return view;
}

#pragma mark -- 网络请求

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
            OrderDetails *details = [OrderDetails mj_objectWithKeyValues:info];
            self.orderDetails = details;
            
            NSArray *goods = dataBack[@"content"][@"info"][@"goods"];
            
            self.goods = [Order mj_objectArrayWithKeyValuesArray:goods];
            
            
            if (details.coupon_price > 0.001 ) {//有优惠券
                
                _arr = @[@"影院：",@"原价：",@"优惠减免：",@"实付："];
            } else { //没有优惠券
                
                _arr = @[@"影院：",@"总价："];
                
            }

            
            if (self.goods.count != 0) {
                self.tableView.tableHeaderView = [self tableViewHeaderView];
                self.tableView.tableFooterView = [self tableViewFooterView];
                [self.tableView reloadData];
            }
            
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
    }];
}


@end
