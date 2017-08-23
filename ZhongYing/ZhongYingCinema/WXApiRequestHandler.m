//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@implementation WXApiRequestHandler

#pragma mark - Public Methods

+ (NSString *)jumpToBizPayContent:(NSDictionary *)content
{
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    if(content != nil){
        
        NSMutableString *stamp  = [content objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[[PayReq alloc] init]autorelease];
        req.partnerId           = [content objectForKey:@"partnerid"];
        req.prepayId            = [content objectForKey:@"prepayid"];
        req.nonceStr            = [content objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [content objectForKey:@"package"];
        req.sign                = [content objectForKey:@"sign"];
        [WXApi sendReq:req];
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[content objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        return @"";
    }else{
        return @"未获取到订单信息!";
    }
}
@end
