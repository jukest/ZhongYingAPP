//
//  ZYConstant.h
//  ZhongYingCinema
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark --  首页常量
/** 首页头部图片高度 */
UIKIT_EXTERN CGFloat const CinemaViewControllerHeaderScrollImageH;

/** 首页电影分类标签的高度 */
UIKIT_EXTERN CGFloat const CinemaViewControllerFilmCagetoryTagViewH;

/** 正在热映电影cell的列间距 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellInteritemSpace;

/** 正在热映电影cell的行间距  */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellLineSpace;

/** 正在热映电影cell的宽度 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellWidth;

/** 正在热映电影cell的高度 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellHeight;

/** 正在热映电影cell的电影图片的高度 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellFilmImgHeight;

/** 正在热映电影名label的高度 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellFilmNameLabelH;

/** 正在热映电影cell间控件的间距  */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellMarge;

/** 正在热映电影cell的购票按钮的宽度 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellBuyBtnW;

/** 正在热映电影cell的3D按钮的宽度 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCell3DBtnW;

/** 正在热映电影cell的对电影的描述label的高度 */
UIKIT_EXTERN CGFloat const ItemBaseViewConllectViewCellDescrip;

#pragma mark -- 资讯常量
/** 资讯首页tableViewcell的高度 */
UIKIT_EXTERN CGFloat const InformationViewControllerTableViewCellHeight;

/** 资讯首页头部图片的高度 */
UIKIT_EXTERN CGFloat const InformationViewControllerTableViewHeaderImgHeight;

/** 资讯首页tableViewcell中图片的宽度 */
UIKIT_EXTERN CGFloat const InformationViewControllerTableViewCellImgWidth;

#pragma mark -- 商场常量

/** 商场首页cell的高度 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellHeight;

/** 商场首页cell上图片的高度 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellImgViewHeight;

/** 商场首页cell上图片的宽度 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellImgViewWeight;

/** 商城首页cell上美食名字的高度 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellMallNameHeight;

/** 商城首页cell上美食价格label的高度 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellMallPriceHeight;

/** 商城界面的间距 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerMarge;

/** 商城首页cell + - 按钮的宽高 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellBtnWH;

/** 商城首页cell 显示数量的宽 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellNumberLabelWidth;

/** 商城首页cell 显示数量的高 */
UIKIT_EXTERN CGFloat const ZYMallViewControllerCellNumberLabelHeight;

/** 商城确认订单页tableViewSectionFooter的高度 */
UIKIT_EXTERN CGFloat const ZYMallConfirmViewControllerTableViewSectionFooterVierHeight;

/** 商城确认订单页tableViewSectionFooter上label的高度  */
UIKIT_EXTERN CGFloat const ZYMallConfirmViewControllerTableViewSectionFooterVierLabelHeight;

#pragma mark -- ZYConfirmTicketOrderViewController 常量

/** 确认订单详情页的 间距 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerMarge;

/** 确认订单详情页的左右边距 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerLeftRigthMarge;

/** 确认订单详情 头 距离顶部的高度 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerHeaderMarge;

/** 确认订单详情 头 大label的高度 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerHeaderBigLabelHeight;

/** 确认订单详情 头 小label的高度 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerHeaderSmallLabelHeight;

/** 确认订单详情 中间内容 大label的高度 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerMidellContentBigLabelHeight;

/** 确认订单详情 中间内容 小label的高度 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerMidellContentSmallLabelHeight;

/** 确认订单详情 中间内容 距离 头 的高度 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerMidellContentTopMarge;

/** 大号字体 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerBigFont;

/** 小号字体 */
UIKIT_EXTERN CGFloat const ZYConfirmTicketOrderViewControllerSmallFont;

/** 确认订单详情 头部 圆角半径 */
UIKIT_EXTERN CGFloat const ZYConfirmOrderTableViewHeaderRadius;

/** 确认订单详情 头部圆角矩形 的 边距 */
UIKIT_EXTERN CGFloat const ZYConfirmOrderTableViewHeaderMarge;

/** 确认订单详情 头部 虚线距离底部的高度 */
UIKIT_EXTERN CGFloat const ZYConfirmOrderTableViewHeaderXuXianBottomHeight;


/** 我的枚举 */
typedef enum : NSUInteger {
    MyOrder = 1,
    MyCoupon,
    MyNews,
    NoComment,
    
    MyBill = 5,
    MyFilmCritic,
    AttentionCinema,
    
    MyLove,
    MyComment,
    IntegralMall,
    
    SuggestedStatistics,
    AboutUS
    
} MyEnum;

