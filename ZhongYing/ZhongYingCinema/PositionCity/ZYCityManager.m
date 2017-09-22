//
//  ZYCityManager.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYCityManager.h"
#import "ZYCity.h"
#import "ZYCityGroup.h"

@interface ZYCityManager ()
@end

@implementation ZYCityManager




// 创建静态对象 防止外部访问
static ZYCityManager *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}


// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareCityManager
{
    
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

- (NSArray *)cityGroups {
    if (!_cityGroups) {
        _cityGroups = [self cityGroupArray];
    }
    return _cityGroups;
}

- (NSArray<NSString *> *)cityFirstLetters {
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:10];

    if (!_cityFirstLetters) {
        for (int i = 0; i<self.cityGroups.count; i++) {
            ZYCityGroup *cityGroup = self.cityGroups[i];
            if (i == 0) {
                [titles addObject:@"定位"];
            } else {
                
                [titles addObject:cityGroup.initial];
            }
        }
        _cityFirstLetters = [titles copy];
    }
    
    return _cityFirstLetters;
    
    
}

- (NSArray *)cityGroupArray {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:100];
    
    NSString *fileStr = [[NSBundle mainBundle] pathForResource:@"movie_City.plist" ofType:nil];
    
    NSArray *allCitys = [NSArray arrayWithContentsOfFile:fileStr];
    
    
    for (int i = 0; i<allCitys.count; i++) {
        NSDictionary *citysDic = allCitys[i];
        NSMutableArray *cityModels = [NSMutableArray arrayWithCapacity:10];
        ZYCityGroup *cityGroup = [[ZYCityGroup alloc]init];
        NSArray *citys = citysDic[@"citys"];
        
        for (int j = 0; j<citys.count; j++) {
            
            NSDictionary *cityDic = citys[j];
            ZYCity *city = [[ZYCity alloc]initWithDictionary:cityDic error:nil];
            [cityModels addObject:city];
            
        }
        
        cityGroup.citys = [cityModels copy];
        
        cityGroup.initial = citysDic[@"initial"];
        
        [array addObject:cityGroup];
    }
    
    
    
    
    
    return [array copy];
}
@end
