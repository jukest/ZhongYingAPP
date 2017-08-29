//
//  ZYPositionCityTableViewController.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYPositionCityTableViewController.h"
#import "ZYCityManager.h"
#import "ZYCity.h"
#import "ZYCityGroup.h"
#import "ZYMapManager.h"
#import "MBProgressHUD.h"

@interface ZYPositionCityTableViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic,strong) NSString *cityName;
@end

@implementation ZYPositionCityTableViewController


- (void)dealloc {
    NSLog(@"被释放了");
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.label.textColor = [UIColor blackColor];
    }
    return _hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    
    
    //开启定位
    [[ZYMapManager shareMapManager] starLocation];
    
    __weak typeof(self) weakSelf = self;
    [ZYMapManager shareMapManager].locationBlock = ^(NSString *cityName,BOOL success) {
        
        if (success) {
            
            ZYCityGroup *cityGroup = [ZYCityManager shareCityManager].cityGroups[0];
            ZYCity *city = cityGroup.citys[0];
            city.city_name = cityName;
            
        }else {
            weakSelf.hud.label.text = @"定位失败,请重试";
        }
        
        [weakSelf.hud hideAnimated:YES afterDelay:0.5];
        weakSelf.hud = nil;

        [weakSelf.tableView reloadData];
        
        
    };
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[ZYMapManager shareMapManager] stopLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //FIXME: 修改城市分类组数
    return [ZYCityManager shareCityManager].cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZYCityGroup *cityGroup = [ZYCityManager shareCityManager].cityGroups[section];

    // FIXME: 修改城市数量
    
    return cityGroup.citys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
        ZYCityGroup *cityGroup = [ZYCityManager shareCityManager].cityGroups[indexPath.section];
        ZYCity *city = cityGroup.citys[indexPath.row];
        cell.textLabel.text = city.city_name;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 44;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ZYCityGroup *cityGroup = [ZYCityManager shareCityManager].cityGroups[section];
    return cityGroup.initial;
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return [ZYCityManager shareCityManager].cityFirstLetters;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if ([ZYMapManager shareMapManager].successPosition) {//定位成功
            
            
        } else {//定位失败
            
            self.hud.label.text = @"";
            [self.view addSubview:self.hud];
            
            //获取定位城市
            [[ZYMapManager shareMapManager] starLocation];
            
            return;
            
        }
        
    }

    
    ZYCityGroup *cityGroup = [ZYCityManager shareCityManager].cityGroups[indexPath.section];
    ZYCity *city = cityGroup.citys[indexPath.row];
    
    if (self.positionBlock != nil) {
        self.positionBlock(city.city_name);
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
