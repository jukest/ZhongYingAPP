//
//  MessageDetailsViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/12/7.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MessageDetailsViewCtl.h"

@interface MessageDetailsViewCtl ()<UIWebViewDelegate>
{
    MBProgressHUD *_HUD;
    UIWebView *_webView;
    UIScrollView *_scrollView;
}
@end

@implementation MessageDetailsViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息详情";
    
    UIScrollView *scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -63) target:self];
    [self.view addSubview:scrollView];
    
    CGSize titleSize = [FanShuToolClass createString:self.message.title font:[UIFont systemFontOfSize:18] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth -12 -15 -50, ScreenHeight)];
    UILabel *titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 22, ScreenWidth -12 -15 -50, titleSize.height) text:self.message.title font:[UIFont systemFontOfSize:18] textColor:Color(67, 67, 67, 1.0) alignment:NSTextAlignmentLeft];
    titleLb.numberOfLines = 0;
    [scrollView addSubview:titleLb];
    
    UILabel *timeLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -15 -50, 22, 50, 13) text:self.message.created_time font:[UIFont systemFontOfSize:15] textColor:Color(80, 80, 80, 1.0) alignment:NSTextAlignmentRight];
    [scrollView addSubview:timeLb];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 22 +titleSize.height, ScreenWidth -24, ScreenHeight)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    //_webView.scalesPageToFit = YES;
    //[_webView sizeToFit];
    
    [scrollView addSubview:_webView];
    _scrollView = scrollView;
    
    [self loadMessageDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods
- (void)loadMessageDetail
{
    if (_HUD == nil) {
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
        [self.view addSubview:_HUD];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMessageDetailURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"message_id"] = self.message.id;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            NSLog(@"getMessageDetails >>>>>>>>>>>>>>>>> %@",dataBack);
            //[NSString stringWithFormat:@"%@%@",BASE_URL,dataBack[@"content"][@"url"]]
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,dataBack[@"content"][@"url"]]]]];
            
        }else if([dataBack[@"code"] integerValue] == 46005){
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
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,webView.bounds.size.width,webView.bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    // document.documentElement.scrollHeight
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] integerValue];
    _webView.frame=CGRectMake(12, _webView.frame.origin.y, _webView.frame.size.width, height);
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth, _webView.frame.origin.y +height);
    
}


@end
