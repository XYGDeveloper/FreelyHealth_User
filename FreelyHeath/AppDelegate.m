//
//  AppDelegate.m
//  FreelyHeath
//
//  Created by L on 2017/7/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <RongCallLib/RongCallLib.h>
#import <RongCallKit/RongCallKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "WXApiManager.h"
#import "WXApi.h"
#import "AlipayApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayService.h"
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import "WXPayService.h"
#import "WKWebViewController.h"
#import "Udesk.h"
#import "UdeskManager.h"
#import "SDetailViewController.h"
#import "MeViewController.h"
#import "ConsultViewController.h"
#import "SDetailViewController.h"
#import "MeViewController.h"
#import "ConsultViewController.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>
#import "UpdateControlManager.h"
#import <RMTabBarViewController.h>
#import "ZYindexViewController.h"
#import "UIAlertView+Block.h"
#import "LoginViewController.h"
#import "AuditedViewController.h"
#import "AppionmentNoticeViewController.h"
#import "AppionmentDetailViewController.h"
#import "MessageListViewController.h"
#import "SecurityUtil.h"
#import "LYZAdView.h"
#import "GetConponManager.h"
#define kFetchTag 1000
#import "RootManager.h"
static NSString *appKey = @"3da7c4cb8142088627ed21d2";
static NSString *channel = @"AppStore";
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）

@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,WXApiDelegate,RCIMConnectionStatusDelegate,
RCIMReceiveMessageDelegate,JPUSHRegisterDelegate,UNUserNotificationCenterDelegate,BaseMessageViewDelegate,ApiRequestDelegate>

@end

@implementation AppDelegate

+(AppDelegate *)APP{
    return (AppDelegate*) [UIApplication sharedApplication].delegate;
}
- (getMessageCountApi *)countApi{
    if (!_countApi) {
        _countApi = [[getMessageCountApi alloc]init];
        _countApi.delegate  =self;
    }
    return _countApi;
}

- (void)refreshWithMessagecount{
    if ([User hasLogin]) {
        myMessageHeader *head = [[myMessageHeader alloc]init];
        head.target = @"userMsgControl";
        head.method = @"queryUserMsgCounts";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        myMessageBody *body = [[myMessageBody alloc]init];
        MymessageListRequest *request = [[MymessageListRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.countApi getMessageCounts:request.mj_keyValues.mutableCopy];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    int messageCount = (int)responsObject[@"userMsgCounts"];
    int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                          getUnreadCount:@[
                                           @(ConversationType_PRIVATE),
                                           @(ConversationType_GROUP)
                                           ]];
    int udeskMessageCOunt = (int)[UdeskManager getLocalUnreadeMessagesCount];
    int messageCounts = messageCount + unreadMsgCount + udeskMessageCOunt;
//    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:[NSString stringWithFormat:@"您有%d新会诊或转诊消息送达，请点击查看消息",messageCounts] iconImage:[UIImage imageNamed:@"Logo"]];
//    toast.toastType = FFToastTypeSuccess;
//    toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
//    [toast show:^{
//        MessageListViewController *detail = [MessageListViewController new];
//        detail.title = @"消息通知";
//        NavigationController *navi =  [RootManager sharedManager].tabbarController.viewControllers[[RootManager sharedManager].tabbarController.selectedIndex];
//        [navi pushViewController:detail animated:YES];
//    }];
}


- (void)initWithRCim:(NSString *)rcim{
    [[RCIM sharedRCIM] initWithAppKey:rcim];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enableMessageAttachUserInfo =YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList =
    @[ @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_GROUP) ];
    [self setUmeng];
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    [[RCIM sharedRCIM] connectWithToken:[User LocalUser].IMtoken success:^(NSString *userId) {
        NSLog(@"融云登陆成功：%@",userId);
        [User LocalUser].id = userId;
        [User saveToDisk];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"融云登陆错误：%ld",(long)status);
    } tokenIncorrect:^{
        NSLog(@"融云token错误：");
    }];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [RootManager sharedManager].tabbarController;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window makeKeyAndVisible];
    [[UpdateControlManager sharedUpdate] updateVersion];
    [[GetConponManager sharedConpon] getConpon];
    [self initWithRCim:RCIM_APPKEY];
    //设置接收消息代理
    [self setUmeng];
    [WXApi registerApp:@"wx949e3c663e1f742e"];
    [AppDelegate progressWKContentViewCrash];
    UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:@"freelyhealth.udesk.cn" appKey:@"ebbbdedbc4f0ecc4004bdc93b5d6d254" appId:@"947947b1f6b28b5a"];
    UdeskCustomer *customer = [UdeskCustomer new];
    customer.sdkToken = [User LocalUser].token;
    customer.nickName = [User LocalUser].nickname;
    customer.email = [NSString stringWithFormat:@"%@@163.com",[User LocalUser].phone];
    customer.cellphone = [User LocalUser].phone;
    customer.customerDescription = [NSString stringWithFormat:@"性别：%@  年龄：%@",[User LocalUser].sex,[User LocalUser].age];
    [UdeskManager initWithOrganization:organization customer:customer];
    
    BOOL isProduction = YES;
#ifdef DEBUG
    NSLog(@"debug");
#else
    
    isProduction = NO;
    
#endif
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            //iOS10特有
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            // 必须写代理，不然无法监听通知的接收与点击
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    // 点击允许
                    NSLog(@"注册成功");
                    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        NSLog(@"%@", settings);
                    }];
                } else {
                    // 点击不允许
                    NSLog(@"注册失败");
                }
            }];
        }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
            //iOS8 - iOS10
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
            
        }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            //iOS8系统以下
            [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
        }
        // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [self setJSPushWithToken:[User LocalUser].token];

    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            [UdeskManager registerDeviceToken:registrationID];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    [[Udesk_WHC_HttpManager shared]registerNetworkStatusMoniterEvent];
    [UMConfigure initWithAppkey:@"5976a575310c933f350018b7" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    return YES;
}

- (void)setJSPushWithToken:(NSString *)token{
    [JPUSHService setAlias:token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"iResCode = %ld, iAlias = %@, seq = %ld", iResCode, iAlias, seq);
    } seq:1];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark-iOS 11.0 _WKWebview

+ (void)progressWKContentViewCrash {
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        const char *className = @"WKContentView".UTF8String;
        Class WKContentViewClass = objc_getClass(className);
        SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
        SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
        BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
        BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
        if (!addIsSecureTextEntry || !addSecureTextEntry) {
            NSLog(@"WKContentView-Crash->修复失败");
        }
    }
}

BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

#pragma mark- Umeng share

- (void)setUmeng{
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5976a575310c933f350018b7"];
    [self configUSharePlatforms];
    [self confitUShareSettings];
}

- (void)confitUShareSettings
{
//    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx949e3c663e1f742e" appSecret:@"bab9ab053523bd0183fa830124f57374" redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106309096"  appSecret:nil redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2331783202"  appSecret:@"dff338b5371e68f8c3fbf4833f6a612d" redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoak5hqhuvmpfhpnjvt" appSecret:nil redirectURL:nil];
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2017101309277880" appSecret:nil redirectURL:nil];
}

#pragma mark  RCIM

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@",url);
    
    return [self canHandleOpenURL:url];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"%@  %@",url,url.host);
    return [self canHandleOpenURL:url];
}

- (BOOL)canHandleOpenURL:(NSURL *)url {
    BOOL result = NO;
    if ([url.host isEqualToString:@"pay"]) { //微信支付
        return  [WXApi handleOpenURL:url delegate:[WXPayService defaultService]];
    }else if ([url.host isEqualToString:@"safepay"]) {//支付宝支付
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[AlipayService defaultService] payOrderDidFinishedWithInfo:resultDic];
        }];
        return YES;
    }
    else {
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return result;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //上线操作，拉取离线消息
    [UdeskManager setupCustomerOnline];
    [application setApplicationIconBadgeNumber:0];
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">"
                        withString:@""] stringByReplacingOccurrencesOfString:@" "
                       withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"%@",[JPUSHService registrationID]);
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
        [application setApplicationIconBadgeNumber:1];
        
        completionHandler(UIBackgroundFetchResultNewData);
        
        [JPUSHService handleRemoteNotification:userInfo];
        
        /**
         * 统计推送打开率2
         */
        [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
        /**
         * 获取融云推送服务扩展字段2
         */
        NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
        if (pushServiceData) {
            NSLog(@"该远程推送包含来自融云的推送服务");
            for (id key in [pushServiceData allKeys]) {
                NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
            }
        } else {
            NSLog(@"该远程推送不包含来自融云的推送服务");
        }
        if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
            //        [rootViewController addNotificationCount];
        }
        completionHandler(UIBackgroundFetchResultNewData);
    }
   
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];

}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知-------:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageCount" object:nil];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
  
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler { 
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        //        [rootViewController addNotificationCount];
        if ([userInfo[@"forWardTarget"] isEqualToString:@"0001"]) {
                AppionmentDetailViewController *audi = [[AppionmentDetailViewController alloc]init];
                audi.title = @"会诊详情";
                audi.id = userInfo[@"mdtid"];
                NavigationController *navi = (NavigationController *)[RootManager sharedManager].tabbarController.viewControllers[[RootManager sharedManager].tabbarController.selectedIndex];
                [navi pushViewController:audi animated:YES];
        }
//        "_j_business" = 1;
//        "_j_msgid" = 2747930256;
//        "_j_uid" = 17453954569;
//        aps =     {
//            alert = "您好，你的申请专家会诊预约已经成功受理。会诊主题：给哈哈哈，会诊专家：小鱼儿,王海,测试02。会诊时间：2018-06-05，为了避免影响您的使用，请尽快登录直医“我的会诊请求”进行订单支付。支付及发票问题请致电400-900-1169。";
//            badge = 2;
//            category = "直医";
//            sound = "";
//        };
//        forWardTarget = 0001;
//        mdtid = 1a364d329d7c4a04a2e8af7765cdd28d;
//        msgid = f7216c39ef274332a21fc92bc5664303;
//    }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

#endif

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //    __block UIBackgroundTaskIdentifier background_task;
    //    //注册一个后台任务，告诉系统我们需要向系统借一些事件
    //    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
    //        //不管有没有完成，结束background_task任务
    //        [application endBackgroundTask: background_task];
    //        background_task = UIBackgroundTaskInvalid;
    //    }];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        //根据需求 开启／关闭 通知
    //        [UdeskManager startUdeskPush];
    //    });
    //
    //    [self saveConversationInfoForMessageShare];
    
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
//    NSNumber *left = [notification.userInfo objectForKey:@"left"];
//    if (([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue)||[RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Foreground) {
//        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
//                                                                             @(ConversationType_PRIVATE), @(ConversationType_GROUP)
//                                                                             ]];
//        dispatch_async(dispatch_get_main_queue(),^{
//            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
//            [self refreshWithMessagecount];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"messageCount" object:nil];
//            //            self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadMsgCount];
//        });
//    }
}
//设置群组通知消息没有提示音
- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message {
    //当应用处于前台运行，收到消息不会有提示音。
    //  if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
//    return YES;
    //  }
      return NO;
}
//为消息分享保存会话信息
- (void)saveConversationInfoForMessageShare {
    NSArray *conversationList =
    [[RCIMClient sharedRCIMClient] getConversationList:@[ @(ConversationType_PRIVATE), @(ConversationType_GROUP) ]];
    
    NSMutableArray *conversationInfoList = [[NSMutableArray alloc] init];
    if (conversationList.count > 0) {
        for (RCConversation *conversation in conversationList) {
            NSMutableDictionary *conversationInfo = [NSMutableDictionary dictionary];
            [conversationInfo setValue:conversation.targetId forKey:@"targetId"];
            [conversationInfo setValue:@(conversation.conversationType) forKey:@"conversationType"];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
                [conversationInfo setValue:user.name forKey:@"name"];
                [conversationInfo setValue:user.portraitUri forKey:@"portraitUri"];
            } else if (conversation.conversationType == ConversationType_GROUP) {
                RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:conversation.targetId];
                [conversationInfo setValue:group.groupName forKey:@"name"];
                [conversationInfo setValue:group.portraitUri forKey:@"portraitUri"];
            }
            [conversationInfoList addObject:conversationInfo];
        }
    }
    NSURL *sharedURL = [[NSFileManager defaultManager]
                        containerURLForSecurityApplicationGroupIdentifier:@"group.cn.rongcloud.im.share"];
    NSURL *fileURL = [sharedURL URLByAppendingPathComponent:@"rongcloudShare.plist"];
    [conversationInfoList writeToURL:fileURL atomically:YES];
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    [shareUserDefaults setValue:[RCIM sharedRCIM].currentUserInfo.userId forKey:@"currentUserId"];
    [shareUserDefaults setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"] forKey:@"Cookie"];
    [shareUserDefaults synchronize];
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [User clearLocalUser];
        [[RCIMClient sharedRCIMClient] disconnect];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutScuess" object:nil];
        UIAlertView *alert =  [UIAlertView alertViewWithTitle:@"退出登录通知" message:@"您的帐号在其他手机设备中登录,此设备账号登录被迫下线，需要重新登录账号" cancelButtonTitle:nil otherButtonTitles:@[@"重新登录"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
                [[RootManager sharedManager].tabbarController presentViewController:nav animated:YES completion:nil];
            }
        }];
        [alert show];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        
    }else if (status == ConnectionStatus_DISCONN_EXCEPTION){
        [[RCIMClient sharedRCIMClient] disconnect];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号被封禁"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[
                                               @(ConversationType_PRIVATE),
                                               @(ConversationType_GROUP)
                                               ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
    
}


#pragma mark- RongCDloudDelegate---


- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion { 
   
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion { 
    
}

@end
