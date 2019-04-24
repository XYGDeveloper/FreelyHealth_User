//
//  Url.h
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#ifndef Url_h
#define Url_h

//--------------------------------------------域名配置---------------------------------------------

//发布环境
#define kApiDomin   @"https://api.zhiyi365.cn/qd/api/client/services"
//测试环境
//#define kApiDomin   @"https://wxapp.zhiyi365.cn/qd/api/client/services"
//本地测试
//#define kApiDomin   @"http://192.168.1.146:8080/qd/api/client/services"

#define kH5Domin   @"https://api.zhiyi365.cn"

#define AssenmentPage [kH5Domin stringByAppendingString:@"/h5/pinggu_list.html"]

#define Versioncode  [UIDevice currentDevice].systemVersion

#define Devicenum  [UDIDIdenity UDID]

#define Fromtype  @"2"

//---------------------------------------------通用参数-------------------------------------------
//订单状态
static NSString *const OrderReqStatusAllOrder = @"";
static NSString *const OrderReqStatusWaitRece = @"1";
static NSString *const OrderReqStatusReceived = @"2";
static NSString *const OrderReqStatusFinished = @"3";

//---------------------------------------------接口列表-------------------------------------------
#define KNotification_cancel @"KNotification_CanOrder"
#define KNotification_topay @"KNotification_ToOrder"
#define KNotification_RefreshList @"KNotification_RefreshList"

//-----------------------------------------------------------------------------------------------
//预约状态
static NSString *const AppionmentReqStatusAll = @"1";
static NSString *const AppionmentReqStatusWaitReview = @"2";
static NSString *const AppionmentReqStatusWaitAppionment = @"3";
static NSString *const AppionmentReqStatusFinished = @"4";
//外链统一管理

//去评估
#define tovalute_URL @"https://api.zhiyi365.cn/h5/pinggu_list.html"

//国际保险
#define NationInsure_URL @"http://nglwx.gwcslife.com/external/ex_fumeiShare.action?shareCode=YJ787&productCode=00199005"
#define AiKang_URL @"http://ee.ikang.com/employee/platform/freelyhealth"

//基因检测
#define Gen_item_URL1 @"https://api.zhiyi365.cn/gene/index_1.html"
#define Gen_item_URL2 @"https://api.zhiyi365.cn/gene/index_2.html"
#define Gen_item_URL3 @"https://api.zhiyi365.cn/gene/index_3.html"
#define Gen_item_URL4 @"https://api.zhiyi365.cn/gene/index_4.html"
#define Gen_item_URL5 @"https://api.zhiyi365.cn/gene/index_5.html"
#define Gen_item_URL6 @"https://api.zhiyi365.cn/gene/index_6.html"

//体检检测
#define Phy_item_URL2 @"https://api.zhiyi365.cn/Employee/index_1.html"
#define Phy_item_URL3 @"https://api.zhiyi365.cn/Employee/index_2.html"
#define Phy_item_URL4 @"https://api.zhiyi365.cn/Employee/index_3.html"
#define Phy_item_URL5 @"https://api.zhiyi365.cn/Employee/index_4.html"
//视频会诊
#define video_hz_URL5 @"https://wxapp.zhiyi365.cn/h5/consult.html"
#endif /* Url_h */
