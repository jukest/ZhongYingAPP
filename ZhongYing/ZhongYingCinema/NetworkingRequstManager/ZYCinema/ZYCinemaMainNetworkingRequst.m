//
//  ZYCinemaMainNetworkingRequst.m
//  ZhongYingCinema
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "ZYCinemaMainNetworkingRequst.h"
#import "HotFilm.h"
#import "Cinema.h"


@interface ZYCinemaMainNetworkingRequst ()
@property (nonatomic,assign)NSInteger nowPlayingCurrentPage;
@property (nonatomic,assign)NSInteger willPlayCurrentPage;
@end

@implementation ZYCinemaMainNetworkingRequst
// 使用线程创造单例
+ (ZYCinemaMainNetworkingRequst *)shareInstance{
    static dispatch_once_t onceToken;
    static ZYCinemaMainNetworkingRequst *connect = nil;
    dispatch_once(&onceToken,^{
        connect = [[ZYCinemaMainNetworkingRequst alloc]init];
    });
    return connect;
}

- (NSMutableArray *)willPlayFilmsArray {
    if (!_willPlayFilmsArray) {
        _willPlayFilmsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _willPlayFilmsArray;
}

- (NSMutableArray *)nowPlayingFilmArray {
    if (!_nowPlayingFilmArray) {
        _nowPlayingFilmArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _nowPlayingFilmArray;
}

- (NSMutableArray *)sliderImgsArray {
    if (!_sliderImgsArray) {
        _sliderImgsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _sliderImgsArray;
}

- (AFHTTPRequestOperationManager *)loadNowPlayingFilmWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void (^)(BOOL, NSString *))result {
    self.nowPlayingCurrentPage = [parameters[@"page"] integerValue];

    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
   AFHTTPRequestOperationManager *manager = [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        NSLog(@"getCinemaMessage >>>>>> %@",dataBack);
        
        if ([dataBack[@"code"] integerValue] == 0) {
            
            NSDictionary *content = dataBack[@"content"];
            NSArray *nowPlayingFilmModels = [HotFilm mj_objectArrayWithKeyValuesArray:content[@"hot_films"]];
            
            if (self.nowPlayingCurrentPage == 0) {
                [self.nowPlayingFilmArray removeAllObjects];
                [self.sliderImgsArray removeAllObjects];
                
                [self.nowPlayingFilmArray addObjectsFromArray:nowPlayingFilmModels];
                
                if (![content[@"sliders"] isEqual:[NSNull null]]) {
                    [self.sliderImgsArray addObjectsFromArray:content[@"sliders"]];
                }
                
                for (int i = 0; i < self.sliderImgsArray.count; i ++) {
                    [self.sliderImgsArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@",Image_URL,self.sliderImgsArray[i]]];
                }
                
                //影院信息
                NSError *cinema_error;
                self.cinemaMsg = [[Cinema alloc] initWithDictionary:content[@"cinema"] error:&cinema_error];
                self.cinemaMsg.id = content[@"cinema"][@"cinema_id"];
                
                
                if (self.nowPlayingFilmArray.count == 0) {
                    result(YES,@"没有电影信息");
                } else {
                    result(YES,nil);
                }
                
            } else {
                [self.nowPlayingFilmArray addObjectsFromArray:nowPlayingFilmModels];
                result(YES,nil);
            }
        } else if ([dataBack[@"code"] intValue] == 46005){
            if (self.nowPlayingCurrentPage == 0) {
                result(NO,@"没有电影信息!");
                
            }else{
                result(NO,@"没有更多了!");
            }
        }else{
            result(NO,dataBack[@"message"]);
        }
    } failure:^(NSError *error) {
        result(NO,@"连接服务器失败!");
        
    }];

    return manager;
}


- (AFHTTPRequestOperationManager *)loadWillPlayFilmWithURL:(NSString *)urlStr withParameters:(NSDictionary *)parameters completeHandle:(void(^)(BOOL,NSString *))result {
     ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    AFHTTPRequestOperationManager *manager = [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        self.willPlayCurrentPage = [parameters[@"page"] integerValue];
        NSLog(@"Api/Common/upComing%@",dataBack);
        
        if ([dataBack[@"code"] integerValue] == 0) {
            
            NSDictionary *content = dataBack[@"content"];
            NSArray *nowPlayingFilmModels = [HotFilm mj_objectArrayWithKeyValuesArray:content[@"film"]];
            
            if (self.willPlayCurrentPage == 0) {
                [self.willPlayFilmsArray removeAllObjects];
                
                [self.willPlayFilmsArray addObjectsFromArray:nowPlayingFilmModels];
                
                
                if (self.willPlayFilmsArray.count == 0) {
//                    result(YES,@"没有电影信息");
                } else {
                    result(YES,nil);
                }
                
            } else {
                [self.willPlayFilmsArray addObjectsFromArray:nowPlayingFilmModels];
                result(YES,nil);
            }
        } else if ([dataBack[@"code"] intValue] == 46005){
            if (self.willPlayFilmsArray == 0) {
                result(NO,@"没有电影信息!");
                
            }else{
                result(NO,@"没有更多了!");
            }
        }else{
            result(NO,dataBack[@"message"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
    return manager;
}

@end























