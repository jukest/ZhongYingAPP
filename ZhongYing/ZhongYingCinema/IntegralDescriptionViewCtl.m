//
//  IntegralDescriptionViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/9.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "IntegralDescriptionViewCtl.h"

@interface IntegralDescriptionViewCtl ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIScrollView *_scrollView;
    MBProgressHUD *_HUD;
}
@end

@implementation IntegralDescriptionViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"积分说明";
    
    UIScrollView *scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -64) target:self];
    [self.view addSubview:scrollView];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-24, ScreenHeight)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    //_webView.scalesPageToFit = YES;
    //[_webView sizeToFit];
    
    [scrollView addSubview:_webView];
    _scrollView = scrollView;
    
    [self loadScoreExplain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - help Method
- (void)loadScoreExplain
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserScoreExplainURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"cinema_id"] = ApiCinemaIDStr;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getScoreExplain >>>>>>>>>>>>> %@",dataBack);
        if ([dataBack[@"code"] intValue] == 0) {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,dataBack[@"content"][@"url"]]]]];
        }else if([dataBack[@"code"] integerValue] == 46005){
            [self showHudMessage:@"您还没有优惠券哦~"];
            [_HUD hide:YES];
        }else{
            [self showHudMessage:dataBack[@"message"]];
            [_HUD hide:YES];
        }
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_HUD hide:YES];
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] integerValue];
    _webView.frame=CGRectMake(12, 0, ScreenWidth-24, height);
}

@end
