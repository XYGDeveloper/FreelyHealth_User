//
//  UdeskSDKManager.h
//  UdeskSDK
//
//  Created by Udesk on 16/8/18.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UdeskSDKConfig.h"
@class UdeskChatViewController;
@class UdeskLocationModel;

typedef enum : NSUInteger {
    UdeskFAQ,
    UdeskIM,
    UdeskTicket
} UdeskType;

@interface UdeskSDKManager : NSObject

/** 是否隐藏语音 */
@property (nonatomic, assign) BOOL     hiddenVoiceButton;

/** 是否隐藏表情 */
@property (nonatomic, assign) BOOL     hiddenEmotionButton;

/** 是否隐藏相机 */
@property (nonatomic, assign) BOOL     hiddenCameraButton;

/** 是否隐藏相册 */
@property (nonatomic, assign) BOOL     hiddenAlbumButton;

/** 是否隐藏定位(默认隐藏) */
@property (nonatomic, assign) BOOL     hiddenLocationButton;

/** 是否隐藏发送视频 */
@property (nonatomic, assign) BOOL     hiddenSendVideo;

/**
 * 类方法调用 
 */
+ (instancetype)managerWithSDKStyle:(UdeskSDKStyle *)style;

/**
 * 对象方法调用
 */
- (instancetype)initWithSDKStyle:(UdeskSDKStyle *)style;

/**
 * 新版本根据app_id进行后台配置的设置
 * 在一个ViewController中Push出一个客服聊天界面
 * @param viewController 在这个viewController中push出客服聊天界面
 */
- (void)pushUdeskInViewController:(UIViewController *)viewController
                       completion:(void (^)(void))completion;

/**
 * 新版本根据app_id进行后台配置的设置
 * 在一个ViewController中Present出一个客服聊天界面的Modal视图
 * @param viewController 在这个viewController中push出客服聊天界面
 */
- (void)presentUdeskInViewController:(UIViewController *)viewController
                          completion:(void (^)(void))completion;

/**
 进入udesk页面

 @param viewController 在一个ViewController中Push出一个客服聊天界面
 @param udeskType 视图类型
 @param completion 完成回调
 */
- (void)pushUdeskInViewController:(UIViewController *)viewController
                        udeskType:(UdeskType)udeskType
                       completion:(void (^)(void))completion NS_DEPRECATED_IOS(3.5,3.6.3, "不建议你使用这个API，推荐使用“pushUdeskInViewController:”");

/**
 进入udesk页面
 
 @param viewController 在一个ViewController中Push出一个客服聊天界面
 @param udeskType 视图类型
 @param completion 完成回调
 */
- (void)presentUdeskInViewController:(UIViewController *)viewController
                           udeskType:(UdeskType)udeskType
                          completion:(void (^)(void))completion NS_DEPRECATED_IOS(3.5,3.6.3, "不建议你使用这个API，推荐使用“pushUdeskInViewController:”");

/**
 *  设置分配给指定的客服id
 *
 *  @param agentId 客服id
 */
- (void)setScheduledAgentId:(NSString *)agentId;

/**
 *  设置分配给指定的客服组id
 *
 *  @param groupId 客服组id
 */
- (void)setScheduledGroupId:(NSString *)groupId;
/**
 *  设置显示咨询对象消息
 *
 *  @param product 咨询对象
 */
- (void)setProductMessage:(NSDictionary *)product;

/**
 *  通过本地图片设置客户头像
 *
 *  @param avatarImage 客户头像
 */
- (void)setCustomerAvatarWithImage:(UIImage *)avatarImage;

/**
 *  通过URL设置客户头像
 *
 *  @param avatarURL 客户头像URL
 */
- (void)setCustomerAvatarWithURL:(NSString *)avatarURL;
/**
 *  设置IM导航栏标题
 *
 *  @param title IM标题
 */
- (void)setIMNavigationTitle:(NSString *)title;
/**
 *  设置智能机器人导航栏标题
 *
 *  @param title 智能机器人标题
 */
- (void)setRobotNavigationTitle:(NSString *)title;
/**
 *  设置帮助中心导航栏标题
 *
 *  @param title 帮助中心标题
 */
- (void)setFAQNavigationTitle:(NSString *)title;
/**
 *  设置帮助中心导航栏标题
 *
 *  @param title 帮助中心标题
 */
- (void)setTicketNavigationTitle:(NSString *)title;
/**
 *  设置帮助中心文章导航栏标题
 *
 *  @param title 帮助中心标题
 */
- (void)setArticleNavigationTitle:(NSString *)title;
/**
 *  设置帮助中心文章导航栏标题
 *
 *  @param title 帮助中心标题
 */
- (void)setAgentMenuNavigationTitle:(NSString *)title;
/**
 *  设置转人工按钮
 *
 *  @param text 转人工
 */
- (void)setTransferText:(NSString *)text;
/**
 *  设置转人工到客服导航栏菜单
 *
 */
- (void)setTransferToAgentMenu:(BOOL)toMenu;

/**
 * 设置组名
 */
- (void)setGroupName:(NSString *)name;

/**
 * 设置排队放弃类型
 */
- (void)setQuitQueueType:(UDQuitQueueType)type;

/**
 离线留言点击事件

 @param completion 事件完成回调
 */
- (void)leaveMessageButtonAction:(void(^)(UIViewController *viewController))completion;

/**
 结构化消息点击事件
 
 @param completion 事件完成回调
 */
- (void)structMessageButtonCallBack:(void(^)(void))completion;

/**
 离开聊天页面回调
 
 @param completion 事件完成回调
 */
- (void)leaveChatViewControllerCallBack:(void(^)(void))completion;

/**
 地理位置功能按钮点击事件

 @param completion 回调viewModel
 * 等你要发送消息的时候可以 viewModel sendLocationMessage:
 */
- (void)locationButtonCallBack:(void(^)(UdeskChatViewController *viewController))completion;

/**
 地理位置消息点击事件

 @param completion 回调这个消息的model
 */
- (void)locationMessageCallBack:(void(^)(UdeskChatViewController *viewController, UdeskLocationModel *locationModel))completion;

/**
 登陆成功回调

 @param completion 完成回调
 */
- (void)loginSuccessCallBack:(void(^)(void))completion;

/**
 点击链接回调
 @param completion 完成回调
 */
- (void)clickLinkCallBack:(void(^)(UIViewController *viewController,NSURL *URL))completion;

@end
