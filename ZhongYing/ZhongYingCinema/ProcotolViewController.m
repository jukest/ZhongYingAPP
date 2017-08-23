//
//  ProcotolViewController.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "ProcotolViewController.h"

@interface ProcotolViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *_LoadHUD;
    UIWebView *_webView;
    NSString *_urlStr;
    UIScrollView *_scrollView;
}
@end

@implementation ProcotolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册协议";
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -64) target:self];
    [self.view addSubview:scrollView];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-24, ScreenHeight -64)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    //_webView.scalesPageToFit = YES;
    //[_webView sizeToFit];
    
    [scrollView addSubview:_webView];
    _scrollView = scrollView;
    
    [self loadRegistrationAgreement];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRegistrationAgreement
{
    _LoadHUD = [FanShuToolClass createMBProgressHUDWithText:@"" target:self];
    [self.view addSubview:_LoadHUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiPublicRegistrationAgreementURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"group_id"] = ApiGroup_ID;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            _urlStr = dataBack[@"content"][@"url"];
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_urlStr]]]];
        }else{
            [self showHudMessage:dataBack[@"message"]];
            [_LoadHUD hide:YES];
        }
    } failure:^(NSError *error) {
        [_LoadHUD hide:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_LoadHUD hide:YES];
    
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] integerValue];
    _webView.frame=CGRectMake(12, 0, ScreenWidth-24, height);
    _scrollView.contentSize = CGSizeMake(ScreenWidth, height +10);
}

@end
