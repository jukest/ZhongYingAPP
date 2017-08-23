//
//  ZYDefineHeader.h
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/16.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#ifndef ZYDefineHeader_h
#define ZYDefineHeader_h



#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

static const CGFloat  TitleViewHeight = 44;
static CGFloat  NavigationHeight = 64;

#define TabViewScrollToTopNotification @"TabViewScrollToTopNotification"
#define ItemScrollToTopNotification @"ItemScrollToTopNotification"
#define random_color  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];


// 百度地图APP KEY
#define NAVI_TEST_APP_KEY @"ebEBregcbGaLhtSfe2rdnVzUWicf5qoY"
// 友盟APP KEY
#define UM_TEST_APP_KEY @"589bc2b075ca351ce3000887"
// 微信APP KEY 和 APP SECRET
#define UM_WECHAT_APP_KEY @"wx6cc1efe5d854888d"
#define UM_WECHAT_APP_SECRET @"70c409c6e569266a2f8e0ec2cd055a16"
// QQ APP KEY 和 APP SECRET
#define UM_QQ_APP_KEY @"1105978438"
// 新浪APP KEY 和 APP SECRET
#define UM_SINA_APP_KEY @"1082060077"
#define UM_SINA_APP_SECRET @"1ee4bb80cb0ecc082fbb5a69ac177ef0"
// 极光推送APP KEY
#define JPush_APP_KEY @"9e5df00307bad1ce6568d963"

// 获取RGB颜色
#define Color(r,g,b,a)  [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
// 屏幕尺寸
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define widthFloat ScreenWidth / 375
#define heightFloat ScreenHeight / 667
// Xcode版本
#define System_Ver [UIDevice currentDevice].systemVersion.floatValue
// 应用版本
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 状态栏、导航栏、工具栏
#define HEIGHT_STATUSBAR [[UIApplication sharedApplication] statusBarFrame].size.height
#define HEIGHT_NAVBAR self.navigationController.navigationBar.frame.size.height
#define HEIGHT_TABBAR 49

// 导航栏的背景颜色
#define COLOR_NAVAAR Color(252, 186, 0, 1.0)
// 登录判断
#define LoginYesOrNoStr [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLogin"]
// 手机号码
#define ApimobileStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apimobile"]
// 用户姓名
#define ApiNameStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apiname"]
// 用户昵称
#define ApiNickNameStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apinickname"]
// 用户头像
#define ApiavatarStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apiavatar"]
// 性别
#define ApiGenderStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apigender"]
// 年龄
#define ApiAgeStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apiage"]
// 鉴别令牌，调用其他接口用到
#define ApiTokenStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apitoken"]
// 手机定位经度
#define ApiLngStr [[NSUserDefaults standardUserDefaults] objectForKey:@"lng"]
// 手机定位纬度
#define ApiLatStr [[NSUserDefaults standardUserDefaults] objectForKey:@"lat"]
// 影院id
#define ApiCinemaIDStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apicinema_id"]
// 用户id
#define ApiUserIDStr [[NSUserDefaults standardUserDefaults] objectForKey:@"Apiid"]

#define ApiMyRemainStr [[NSUserDefaults standardUserDefaults] objectForKey:@"myremain"]
#define ApiMyScoreStr [[NSUserDefaults standardUserDefaults] objectForKey:@"myscore"]
#define ApiMyCommentStr [[NSUserDefaults standardUserDefaults] objectForKey:@"mycomment"]

// 极光推送registrationID
#define JPushRegistrationID [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"]

// 支付宝操作来源
#define isProcessFromPayment [[NSUserDefaults standardUserDefaults] objectForKey:@"isProcessFromPayment"]

// 保存是否购票
#define isOrderForTicket [[NSUserDefaults standardUserDefaults] objectForKey:@"isOrderForTicket"]

// 影院组id
#define ApiGroup_ID @"1"

#define BASE_URL @"https://www.jkmovies.jukest.cn/"
#define Image_URL @"https://www.jkmovies.jukest.cn"
#define ImageDetail_URL @"https://www.jkmovies.jukest.cn/"

//#define BASE_URL @"http://zytd.ctkey.com.cn/index.php/"
//#define Image_URL @"http://zytd.ctkey.com.cn"
//#define ImageDetail_URL @"http://zytd.ctkey.com.cn/index.php/"

// 公共前缀
//#define BASE_URL @"http://192.168.1.80/zhongying/index.php/"
//#define Image_URL @"http://192.168.1.80/zhongying"
//#define ImageDetail_URL @"http://192.168.1.80/zhongying/index.php/"
// 验证码
#define ApiVerifyURL @"Api/Login/verify"
// 用户登录
#define ApiLoginURL @"Api/Login/login"
// 用户注册
#define ApiRegisterURL @"Api/Login/register"
// 找回密码
#define ApiFindPasswordURL @"Api/Login/findPassword"
// 影院主页
#define ApiCommonCinemaURL @"Api/Common/cinema"
// 影院列表
#define ApiCommonCinemaListURL @"Api/Common/cinemaList"
// 资讯首页
#define ApiCommonNewsURL @"Api/Common/news"
// 资讯列表
#define ApiCommonNewsListURL @"Api/Common/newsList"
// 影院详情
#define ApiCommonCinemaDetailURL @"Api/Common/cinemaDetail"
// 资讯详情
#define ApiCommonNewsDetailURL @"Api/Common/newsDetail"
// 资讯评论列表
#define ApiCommonNewsCommentListURL @"Api/Common/newsCommentList"
// 影院投诉
#define ApiUserComplaintURL @"Api/User/complaint"
// 关注影院列表
#define ApiUserStarListURL @"Api/User/starList"
// 关注影院
#define ApiUserStarURL @"Api/User/star"
// 取消关注影院
#define ApiUserUnstarURL @"Api/User/unstar"
// 新闻评论
#define ApiUserNewsCommentURL @"Api/User/newsComment"
// 影院评论
#define ApiUserCinemaCommentURL @"Api/User/cinemaComment"
// 投诉统计
#define ApiUserMyComplaintURL @"Api/User/myComplaint"
// 我的影院评论列表
#define ApiUserMyCinemaCommentListURL @"Api/User/myCinemaCommentList"
// 我的资讯评论列表
#define ApiUserMyNewsCommentListURL @"Api/User/myNewsCommentList"
// 删除影院评论
#define ApiUserDeleteCinemaCommentURL @"Api/User/deleteCinemaComment"
// 删除资讯评论
#define ApiUserDeleteNewsCommentURL @"Api/User/deleteNewsComment"
// 修改用户头像
#define ApiUserModifyAvatarURL @"Api/User/modifyAvatar"
// 修改账号信息
#define ApiUserModifyProfileURL @"Api/User/modifyProfile"
// 获取APP版本号
#define ApiPublicVersionURL @"Api/Public/version"
// 获取APP客服信息
#define ApiPublicCustomServiceURL @"Api/Public/customService"
// 获取优惠券
#define ApiUserCouponListURL @"Api/User/couponList"
// 我的消息
#define ApiUserMessageListURL @"Api/User/messageList"
// 消息详情
#define ApiUserMessageDetailURL @"Api/User/messageDetail"
// 删除我的消息
#define ApiUserDeleteMessageURL @"Api/User/deleteMessage"
// 我的订单
#define ApiUserOrderformListURL @"Api/User/orderformList"
// 优惠卷说明
#define ApiUserCouponExplainURL @"Api/User/couponExplain"
// 历史订单
#define ApiUserHistoryOrderformURL @"Api/User/historyOrderform"
// 积分商城列表
#define ApiUserShoplistURL @"Api/User/shoplist"
// 积分兑换记录
#define ApiUserExchangeRecordURL @"Api/User/exchangeRecord"
// 获取积分说明
#define ApiUserScoreExplainURL @"Api/User/scoreExplain"
// 积分商城商品详情
#define ApiUserShopGoodsDetailURL @"Api/User/shopGoodsDetail"
// 影院信息
#define ApiCommonCinemaPlayURL @"Api/Common/cinemaPlay"
// 影片详情
#define ApiCommonMovieURL @"Api/Common/movie"
// 我的首页
#define ApiUserMyselfURL @"Api/User/myself"
// 我的账单
#define ApiUserMyBillURL @"Api/User/myBill"
// 账单详情
#define ApiUserBillDetailURL @"Api/User/billDetail"
// 删除我的账单
#define ApiUserDeleteBillURL @"Api/User/deleteBill"
// 卖品信息
#define ApiCommonGoodsURL @"Api/Common/goods"
// 选座
#define ApiUserSelectSeatURL @"Api/User/selectSeat"
// 我的收藏列表
#define ApiUserMyCollectionListURL @"Api/User/myCollectionList"
// 删除我的收藏
#define ApiUserDeleteMyCollectionURL @"Api/User/deleteMyCollection"
// 我的评论-电影评论列表
#define ApiUserMyMovieCommentListURL @"Api/User/myMovieCommentList"
// 删除我的电影评论
#define ApiUserDeleteMovieCommentURL @"Api/User/deleteMovieComment"
// 待评价列表
#define ApiUserWaitingCommentsListURL @"Api/User/waitingCommentsList"
// 待评价-影片评价
#define ApiUserMovieCommentURL @"Api/User/movieComment"
// 我的影评
#define ApiUserMyFilmCommentListURL @"Api/User/myFilmCommentList"
// 影片热度列表
#define ApiCommonFilmHeatListURL @"Api/Common/filmHeatList"
// 影院--影片收藏
#define ApiUserMovieCollectionURL @"Api/User/movieCollection"
// 影院--取消影片收藏
#define ApiUserCancelCollectionURL @"Api/User/cancelCollection"
// 影院--我要评价
#define ApiUserMakeCommentURL @"Api/User/makeComment"
// 确认订单
#define ApiUserBuyTicketURL @"Api/User/buyTicket"
// 推荐商品
#define ApiUserSouvenirURL @"Api/User/souvenir"
// 支付订单页面
#define ApiUserOrderInfoURL @"Api/User/orderInfo"
// 积分选座
#define ApiUserExchangeTicketURL @"Api/User/exchangeTicket"
// 选座后兑换
#define ApiUserSuccessTicketURL @"Api/User/successTicket"
// 积分兑换卖品
#define ApiUserExchangeGoodsURL @"Api/User/exchangeGoods"
// 推荐卖品优惠卷
#define ApiUserGoodsCouponsURL @"Api/User/goodsCoupons"
// 注册协议
#define ApiPublicRegistrationAgreementURL @"Api/Public/registrationAgreement"
// 卖品订单支付页
#define ApiUserGoodsOrderURL @"Api/User/goodsOrder"
// 支付
#define ApiUserPayOrderURL @"Api/User/payOrder"
// 订单详情
#define ApiUserOrderformDetailURL @"Api/User/orderformDetail"
// 退货退票
#define ApiUserReturnOrderURL @"Api/User/returnOrder"
// 资讯--票房接口
#define ApiUserCommonTicketListURL @"Api/Common/ticketList"
// 用户充值
#define ApiUserRechargeURL @"Api/User/userRecharge"
// 用户充值支付宝回调
#define ApiUserRechargeAlipayValidaURL @"Api/User/rechargeAlipayValida"
// 购买支付宝回调
#define ApiUserAlipayValidaURL @"Api/User/alipayValida"
// 座位解锁
#define ApiUserUnlockURL @"Api/User/unlock"
// 参数入库，上传极光推送registration_id
#define ApiUserParametersURL @"Api/User/parameters"
// 极光推送接口(测试用)
#define ApiPublicNoticeJpushURL @"Api/Public/noticeJpush"
// 开场前30分钟提醒
#define ApiUserGetFilmTimeURL @"Api/User/getFilmTime"
// 获取充值说明
#define ApiUserChargeExplainURL @"Api/User/chargeExplain"
// 切换影院
#define ApiCommonChangeCinemaURL @"Api/Common/changeCinema"
// 
#define ApiPublicAdPageURL @"Api/Public/adPage"

typedef enum {
    LFSPopup_year = 0,// 修改年龄段
    LFSPopup_sex// 修改性别
}LFSPopupStatus;

#endif /* ZYDefineHeader_h */
