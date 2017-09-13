//
//  ZYInformantionMainNetworingRequst.m
//  ZhongYingCinema
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYInformantionMainNetworingRequst.h"
#import "News.h"
#import "BoxOffice.h"

@interface ZYInformantionMainNetworingRequst ()
@property (nonatomic,assign)NSInteger newsCurrentPage;
@property (nonatomic,assign)NSInteger boxOfficeCurrentPage;

@end

@implementation ZYInformantionMainNetworingRequst

- (NSMutableArray *)sliderImgsArray {
    if (!_sliderImgsArray) {
        _sliderImgsArray =  [NSMutableArray arrayWithCapacity:10] ;
    }
    return _sliderImgsArray;
}

- (NSMutableArray *)newsArray {
    if (!_newsArray) {
        _newsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _newsArray;
}

- (NSMutableArray *)boxOfficesArray {
    if (!_boxOfficesArray) {
        _boxOfficesArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _boxOfficesArray;
}

// 使用线程创造单例
+ (ZYInformantionMainNetworingRequst *)shareInstance{
    static dispatch_once_t onceToken;
    static ZYInformantionMainNetworingRequst *connect = nil;
    dispatch_once(&onceToken,^{
        connect = [[ZYInformantionMainNetworingRequst alloc]init];
    });
    return connect;
}

/**
 加载资讯
 
 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
- (AFHTTPRequestOperationManager *)loadNewsWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void (^)(BOOL, NSString *))result {
    self.newsCurrentPage = [parameters[@"page"] integerValue];
    
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
      AFHTTPRequestOperationManager *manager = [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
         NSLog(@"getNewsMessage >>>>>>>>>> %@",dataBack);
         NSDictionary *content = dataBack[@"content"];
          
         NSArray *news = content[@"news"];
          
          NSArray *newModels = [News mj_objectArrayWithKeyValuesArray:news];
          
          if (self.newsCurrentPage == 0) {
              [self.newsArray removeAllObjects];
              [self.sliderImgsArray removeAllObjects];
              
              [self.sliderImgsArray addObjectsFromArray:content[@"sliders"]];
              
              for (int i = 0; i < self.sliderImgsArray.count; i ++) {
                  [self.sliderImgsArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,self.sliderImgsArray[i]]];
              }
              //TODO:--测试
//              [self.sliderImgsArray removeObjectAtIndex:0];
          } else {
              
          }
          [self.newsArray addObjectsFromArray:newModels];
          
          result(YES,nil);
          
        } failure:^(NSError *error) {
            
         result(NO,@"连接服务器失败!");
            
        }];
    
    return manager;
}

/**
 加载票房
 
 @param urlStr url
 @param parameters 参数
 @param result 结果
 @return 网络请求的manager
 */
- (AFHTTPRequestOperationManager *)loadBoxOfficWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void (^)(BOOL, NSString *))result {
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    AFHTTPRequestOperationManager *manager = [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getBoxOfficeList >>>>>>>>>> %@",dataBack);
        self.boxOfficeCurrentPage = [parameters[@"page"] integerValue];
        if ([dataBack[@"code"] integerValue] == 0) {
            if (self.boxOfficeCurrentPage == 0) {
                [self.boxOfficesArray removeAllObjects];
            }
            
            NSDictionary *content = dataBack[@"content"];
            NSArray *boxOfficeModels = [BoxOffice mj_objectArrayWithKeyValuesArray:content[@"list"]];
            [self.boxOfficesArray addObjectsFromArray:boxOfficeModels];
            result(YES,nil);
            
        }else if ([dataBack[@"code"] integerValue] == 46005){
            result(NO,@"没有票房排行");
            
            
        }else{
            result(NO,dataBack[@"message"]);

        }
    } failure:^(NSError *error) {
        result(NO,@"连接服务器失败!");
    }];
    
    return manager;
}


@end

















