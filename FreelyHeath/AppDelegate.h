//
//  AppDelegate.h
//  FreelyHeath
//
//  Created by L on 2017/7/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>
#import <RongCallKit/RongCallKit.h>
#import <RongIMKit/RongIMKit.h>
#import "RMTabBarViewController.h"
#import "getMessageCountApi.h"
#import "MymessageListRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>
//@property(nonatomic,strong)FFToast *popView;
@property (nonatomic,strong)getMessageCountApi *countApi;
@property (strong, nonatomic)UIWindow *window;
@property (nonatomic , strong)RMTabBarViewController *rootTab;

+(AppDelegate*)APP;

+ (void)progressWKContentViewCrash;

@end

