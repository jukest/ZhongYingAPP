//
//  YKGTabBarController.m
//  YiKaiGong
//
//  Created by 小菜皮 on 16/10/26.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "YKGTabBarController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"

@interface YKGTabBarController ()<EAIntroDelegate>

@end

@implementation YKGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加入引导页
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:app_Version]) {
        [self initIntroView];
        [[NSUserDefaults standardUserDefaults] setObject:app_Version forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)initIntroView{
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:self.view.bounds];
    EAIntroPage *page1 = [EAIntroPage pageWithCustomView:imageView1];
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:self.view.bounds];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomView:imageView2];
    
    UIImageView * imageView3 = [[UIImageView alloc] initWithFrame:self.view.bounds];
    EAIntroPage *page3 = [EAIntroPage pageWithCustomView:imageView3];
    
    UIImageView * imageView4 = [[UIImageView alloc] initWithFrame:self.view.bounds];
    EAIntroPage *page4 = [EAIntroPage pageWithCustomView:imageView4];
    
    if (self.view.frame.size.height > 480) {
        imageView1.image = [UIImage imageNamed:@"引导页1"];
        imageView2.image = [UIImage imageNamed:@"引导页2"];
        imageView3.image = [UIImage imageNamed:@"引导页3"];
        imageView4.image = [UIImage imageNamed:@"引导页4"];
    }else{
        imageView1.image = [UIImage imageNamed:@"引导页1"];
        imageView2.image = [UIImage imageNamed:@"引导页2"];
        imageView3.image = [UIImage imageNamed:@"引导页3"];
        imageView4.image = [UIImage imageNamed:@"引导页4"];
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3, page4]];
    intro.backgroundColor = [UIColor blackColor];
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)introDidFinish {
    //发一个 广告消失 的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:AdvertiseViewDismissNotification object:nil];
}

@end
