//
//  AboutUsViewCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/29.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "AboutUsViewCtl.h"
#import "AboutUsCell.h"
#import "UIApplication+Extend.h"

@interface AboutUsViewCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_HUD;
    MBProgressHUD *_versionHUD;
    NSArray *_arr;
    NSString *_ipa_download_url;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aboutUsArr;
@property (nonatomic,assign) NSInteger type;
@end

@implementation AboutUsViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color(246, 246, 246, 1.0);
    self.navigationItem.title = @"关于我们";
    self.type = 1;
    _arr = @[@"当前版本",@"聚客客服电话"];
    [self.aboutUsArr addObject:AppVersion];
    [self.aboutUsArr addObject:@""];
    self.tableView.tableHeaderView = [self getAboutUsTableHeaderView];
    self.tableView.tableFooterView = [self getAboutUsTableFooterView];
    [self loadCustomService];
}

#pragma mark - help Methods
- (void)loadCustomService
{
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"加载中..." target:self];
    [self.view addSubview:_HUD];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiPublicCustomServiceURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"phone";
    parameters[@"group_id"] = ApiGroup_ID;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            [self.aboutUsArr removeLastObject];
            [self.aboutUsArr addObject:dataBack[@"content"][@"result"]];
            self.type = [dataBack[@"content"][@"type"] integerValue];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [self.tableView reloadData];
        [_HUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hide:YES];
    }];
}

- (void)checkForUpdate
{
    _versionHUD = [FanShuToolClass createMBProgressHUDWithText:@"检测中..." target:self];
    [self.view addSubview:_versionHUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiPublicVersionURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"os"] = @"ios";
    parameters[@"version"] = AppVersion;
    parameters[@"group_id"] = ApiGroup_ID;
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            _ipa_download_url = dataBack[@"content"][@"ipa_download_url"];
            if ([dataBack[@"content"][@"result"] isEqualToString:@"lower"]) {
                [self showAlertWithMessage:dataBack[@"content"][@"update_title"] log:dataBack[@"content"][@"update_log"]];
            }else{
                [self showHudMessage:@"已是最新版!"];
            }
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_versionHUD hide:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_versionHUD hide:YES];
    }];
}

/**
 显示提示信息
 
 @param title 提示标题
 @param log   提示信息
 */
- (void)showAlertWithMessage:(NSString *)title log:(NSString *)log
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:log preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        // 服务器后台给一个链接让我更新
        NSURL *updateUrl = [NSURL URLWithString:_ipa_download_url];
        if (updateUrl) {
            if ([[UIApplication sharedApplication] canOpenURL:updateUrl]) {
                
                if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:updateUrl];
                }else{
                    [[UIApplication sharedApplication] openURL:updateUrl options:@{} completionHandler:nil];
                }
            }
        }
    }];
    if ([deleteAction valueForKey:@"titleTextColor"]) {
        [deleteAction setValue:Color(251, 158, 29, 1.0) forKey:@"titleTextColor"];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [deleteAction setValue:Color(251, 158, 29, 1.0) forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)aboutUsArr
{
    if (_aboutUsArr == nil) {
        _aboutUsArr = [NSMutableArray array];
    }
    return _aboutUsArr;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [FanShuToolClass createTableViewPlainWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped target:self];
        [_tableView registerClass:[AboutUsCell class] forCellReuseIdentifier:@"AboutUsCell"];
        _tableView.backgroundColor = Color(246, 246, 246, 1.0);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)getAboutUsTableHeaderView{
    UIView *aboutView = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, 250) color:Color(246, 246, 246, 1.0)];
    
    UIImageView *aboutHeadImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, 75, 75) image:[UIImage imageNamed:@"Login_head"] tag:1000];
    aboutHeadImg.center = CGPointMake(ScreenWidth/2, 125);
    [aboutView addSubview:aboutHeadImg];
    
    UIImage *nameImg = [UIImage imageNamed:@"aboutUs_name"];
    UIImageView *aboutHeadLb = [FanShuToolClass createImageViewWithFrame:CGRectMake(0, 0, nameImg.size.width, nameImg.size.height) image:nameImg tag:909];
    aboutHeadLb.center = CGPointMake(ScreenWidth/2, 200);
    [aboutView addSubview:aboutHeadLb];
    
    return aboutView;
}

- (UIView *)getAboutUsTableFooterView
{
    UIView *copyrightView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -350 -64) backgroundColor:Color(246, 246, 246, 1.0)];
    NSString *copyright = @"Copyright©2016-2017\n深圳聚客网络科技有限公司";
    UILabel *copyrightLb = [FanShuToolClass createLabelWithFrame:CGRectMake(50, ScreenHeight -350 -64 -80, ScreenWidth - 100, 80) text:copyright font:[UIFont systemFontOfSize:15] textColor:Color(60, 60, 60, 1.0) alignment:NSTextAlignmentCenter];
    copyrightLb.attributedText = [FanShuToolClass getAttributeStringWithContent:copyright withLineSpaceing:7];
    copyrightLb.numberOfLines = 0;
    copyrightLb.textAlignment = NSTextAlignmentCenter;
    [copyrightView addSubview:copyrightLb];
    return copyrightView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.type != 1) {
            [self checkForUpdate];
        }
        
    }else{
        NSString *str1 = self.aboutUsArr[indexPath.row];
        NSString *numbers = @"0123456789";
        NSMutableString *str2 = [NSMutableString string];
        for (int i = 0; i < [str1 length]; i ++) {
            if ([numbers containsString:[str1 substringWithRange:NSMakeRange(i, 1)]]) {
                [str2 appendString:[str1 substringWithRange:NSMakeRange(i, 1)]];
            }
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",str2];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
            
            if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
            }
        }else{
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutUsCell *about = [tableView dequeueReusableCellWithIdentifier:@"AboutUsCell"];
    about.aboutUsLeftLb.text = _arr[indexPath.row];
    if (indexPath.row == 0) {
        about.aboutUsRightLb.text = [NSString stringWithFormat:@"V%@",self.aboutUsArr[indexPath.row]];
        about.aboutUsRightLb.textColor = [UIColor blackColor];
    }else {
        about.aboutUsRightLb.text = self.aboutUsArr[indexPath.row];
        about.aboutUsRightLb.textColor = [UIColor redColor];
    }
    return about;
}

@end
