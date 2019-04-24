//
//  ScienDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ScienDetailViewController.h"
#import "TumorZoneListModel.h"
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import <APOpenAPI.h>
#import <DTShareKit/DTOpenAPI.h>

@interface ScienDetailViewController ()

@end

@implementation ScienDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavigationItemWithTitle:@"分享" action:@selector(toshare)];

    // Do any additional setup after loading the view.
}


- (void)toshare{
    
    if (![QQApiInterface isQQInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_QQ];
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_Qzone];
    }
    if (![WXApi isWXAppInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession];
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatFavorite];
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine];
    }

    if (![APOpenAPI isAPAppInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_AlipaySession];
    }
    if ([DTOpenAPI isDingTalkInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_DingDing];
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
    }
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_AlipaySession),@(UMSocialPlatformType_DingDing)]];
   
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString* thumbURL = @"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.title descr:self.model.content thumImage:thumbURL];
    shareObject.webpageUrl = self.model.url;
    
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                [Utils postMessage:@"分享成功！" onView:self.view];
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
        //        [Utils postMessage:error.description onView:self.view];
        
    }];
    
    
}



@end
