//
//  UdeskSDKConfig.h
//  UdeskSDK
//
//  Created by Udesk on 16/1/16.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UdeskSDKStyle.h"
#import "UdeskManager.h"
@class UdeskChatViewController;
@class UdeskLocationModel;

/*
 显示聊天窗口的动画
 */
typedef NS_ENUM(NSUInteger, UDTransiteAnimationType) {
    UDTransiteAnimationTypePresent,
    UDTransiteAnimationTypePush
};

@interface UdeskSDKConfig : NSObject

@property (nonatomic, copy) NSString *hasRobot;

@property (nonatomic, strong) UdeskSDKStyle *sdkStyle;

/** 组来源 */
@property (nonatomic, copy) NSString *name;
/** im标题 */
@property (nonatomic, copy  ) NSString *imTitle;

/** 机器人标题 */
@property (nonatomic, copy  ) NSString *robotTtile;

/** 帮助中心标题 */
@property (nonatomic, copy  ) NSString *faqTitle;

/** 帮助中心文章标题 */
@property (nonatomic, copy  ) NSString *articleTitle;

/** 留言提交工单标题 */
@property (nonatomic, copy  ) NSString *ticketTitle;

/** 客服导航栏菜单标题 */
@property (nonatomic, copy  ) NSString *agentMenuTitle;

/** 机器人转人工 */
@property (nonatomic, copy  ) NSString *transferText;

/** 咨询对象发送文字 */
@property (nonatomic, copy  ) NSString *productSendText;

/** 指定客服id */
@property (nonatomic, copy  ) NSString *scheduledAgentId;

/** 指定客服组id */
@property (nonatomic, copy  ) NSString *scheduledGroupId;

/** 是否转人工至客服导航栏菜单（默认直接进会话） */
@property (nonatomic, assign) BOOL     transferToMenu;

/** 客户头像 */
@property (nonatomic, strong) UIImage  *customerImage;

/** 客户头像URL */
@property (nonatomic, copy  ) NSString *customerImageURL;

/** 咨询对象消息 */
@property (nonatomic, strong) NSDictionary *productDictionary;

/** 页面弹出方式 */
@property (nonatomic, assign) UDTransiteAnimationType presentingAnimation;

/** 放弃排队方式 */
@property (nonatomic, assign) UDQuitQueueType quitQueueType;

/** 超链接正则 */
@property (nonatomic, strong, readonly) NSMutableArray *linkRegexs;

/** 号码正则 */
@property (nonatomic, strong, readonly) NSMutableArray *numberRegexs;

/** 离线留言点击 */
@property (nonatomic, copy) void(^leaveMessageAction)(UIViewController *viewController);

/** 结构化消息回调 */
@property (nonatomic, copy) void(^structMessageCallBack)(void);

/** 离开聊天页面回调 */
@property (nonatomic, copy) void(^leaveChatViewController)(void);

/** 地理位置功能按钮回调 */
@property (nonatomic, copy) void(^locationButtonCallBack)(UdeskChatViewController *viewController);

/** 地理位置消息回调 */
@property (nonatomic, copy) void(^locationMessageCallBack)(UdeskChatViewController *viewController, UdeskLocationModel *locationModel);

/** 登陆成功 */
@property (nonatomic, copy) void(^loginSuccessCallBack)(void);

/** 点击文本链接回调 */
@property (nonatomic, copy) void(^clickLinkCallBack)(UIViewController *viewController,NSURL *URL);

/** 是否隐藏语音 */
@property (nonatomic, assign) BOOL     hiddenVoiceButton;

/** 是否隐藏表情 */
@property (nonatomic, assign) BOOL     hiddenEmotionButton;

/** 是否隐藏相机 */
@property (nonatomic, assign) BOOL     hiddenCameraButton;

/** 是否隐藏相册 */
@property (nonatomic, assign) BOOL     hiddenAlbumButton;

/** 是否隐藏定位 */
@property (nonatomic, assign) BOOL     hiddenLocationButton;

/** 是否隐藏发送视频 */
@property (nonatomic, assign) BOOL     hiddenSendVideo;

+ (instancetype)sharedConfig;

@end
