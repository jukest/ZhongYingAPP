//
//  ZYMemberViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYMemberViewController.h"

@interface ZYMemberViewController ()

@end

@implementation ZYMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];//mall_member
    
    UIImageView *imgView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mall_member"]];
    imgView.frame = CGRectMake(10, 10, ScreenWidth - 20, 200);
    [self.view addSubview:imgView];
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, imgView.height - 70, imgView.width - 20, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = Color(252, 186, 0, 1.0);
    label.text = @"攻城狮们正在努力开发中...";
    
    [imgView addSubview:label];
    
    label.textAlignment = NSTextAlignmentCenter;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
