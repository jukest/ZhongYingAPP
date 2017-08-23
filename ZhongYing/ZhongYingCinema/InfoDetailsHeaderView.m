//
//  InfoDetailsHeaderView.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/23.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "InfoDetailsHeaderView.h"

@interface InfoDetailsHeaderView ()<UIWebViewDelegate>

@end
@implementation InfoDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame details:(NSDictionary *)details
{
    NSString *title = details[@"title"];
    NSString *date = details[@"created_time"];
    NSString *pageviews = details[@"rate"];
    NSString *content = details[@"content"];
    // NSString *url = details[@"url"];
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGSize titleSize = [FanShuToolClass createString:title font:[UIFont systemFontOfSize:18] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth -30, ScreenHeight)];
        self.titleLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15, 20, titleSize.width, titleSize.height) text:title font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        self.titleLb.numberOfLines = 0;
        
        // 设置文字行距
        NSString *titleLabelText = self.titleLb.text;
        self.titleLb.attributedText = [FanShuToolClass getAttributeStringWithContent:titleLabelText withLineSpaceing:5];
        [self.titleLb sizeToFit];
        
        [self addSubview:self.titleLb];
        
        self.dateLb = [FanShuToolClass createLabelWithFrame:CGRectMake(15, 15 + titleSize.height + 20, 150, 10) text:[date transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"] font:[UIFont systemFontOfSize:14] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.dateLb];
        
        self.pageviewsLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth -75, 15 + titleSize.height + 20, 60, 10) text:[NSString stringWithFormat:@"阅读 %@",pageviews] font:[UIFont systemFontOfSize:14] textColor:[UIColor grayColor] alignment:NSTextAlignmentRight];
        [self addSubview:self.pageviewsLb];

        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(12, 15 + titleSize.height + 20 +10 +15, frame.size.width -22, 0)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        [_webView sizeToFit];
        
        ///////////////////////////////设置内容，这里包装一层div，用来获取内容实际高度（像素），htmlcontent是html格式的字符串//////////////
        //NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", content];
        [_webView loadHTMLString:content baseURL:nil];
        
        [self addSubview:_webView];
        
    }
    
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.scrollHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(12, webView.frame.origin.y, self.frame.size.width -22, clientheight +5);
    
    if ([self.delegate respondsToSelector:@selector(getContentHeight:)]) {
        [self.delegate getContentHeight:clientheight +5];
    }
}

- (void)configViewWithDetails:(NSDictionary *)details
{
    NSString *title = details[@"title"];
    NSString *date = details[@"created_time"];
    NSString *pageviews = details[@"rate"];
    NSString *url = details[@"url"];
    NSLog(@"url >>>>>>>>>>>>>> %@",url);
    // 设置文字行距
    NSString *titleLabelText = title;
    self.titleLb.attributedText = [FanShuToolClass getAttributeStringWithContent:titleLabelText withLineSpaceing:5];
    self.dateLb.text = [date transforTomyyyyMMddWithFormatter:@"yyyy-MM-dd"];
    self.pageviewsLb.text = [NSString stringWithFormat:@"阅读 %@",pageviews];
    //[_webView loadHTMLString:content baseURL:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,url]]]];
    
}

@end
