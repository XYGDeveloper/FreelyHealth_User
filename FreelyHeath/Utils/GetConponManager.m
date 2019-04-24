//
//  GetConponManager.m
//  FreelyHeath
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetConponManager.h"
#import "MyconponViewController.h"
#import "RootManager.h"
#import "RMTabBarViewController.h"
@implementation GetConponManager
+ (instancetype)sharedConpon {
    static GetConponManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[GetConponManager alloc] init];
    });
    return __manager;
}

- (void)getConpon{
    if ([User hasLogin]) {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript" ,nil];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        UploadHeader *head = [[UploadHeader alloc]init];
        head.target = @"couponControl";
        head.method = @"queryGetCoupons";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        UploadBody *body = [[UploadBody alloc]init];
        UploadToolRequest *request = [[UploadToolRequest alloc]init];
        request.head = head;
        request.body = body;
        [manager POST:kApiDomin parameters:request.mj_keyValues.mutableCopy success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            if ([[dic objectForKey:@"canget"] intValue] == 1) {
                AdViewMessageObject *messageObject = MakeAdViewObject(@"", @"",@"",NO);
                [LYZAdView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:1101];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            //        result(0);
        }];
    }
}

-(void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == 1101) {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript" ,nil];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        UploadHeader *head = [[UploadHeader alloc]init];
        head.target = @"couponControl";
        head.method = @"distributionCoupon";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        UploadBody *body = [[UploadBody alloc]init];
        UploadToolRequest *request = [[UploadToolRequest alloc]init];
        request.head = head;
        request.body = body;
        [manager POST:kApiDomin parameters:request.mj_keyValues.mutableCopy success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [Utils postMessage:@"领取优惠券成功" onView:[UIApplication sharedApplication].keyWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 获取导航控制器
//                MyconponViewController *conpon = [MyconponViewController new];
//                RMTabBarViewController *tabVC = (RMTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//                BaseNavigationController *pushClassStance = (BaseNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
//                // 跳转到对应的控制器
//                [pushClassStance pushViewController:conpon animated:YES];
                
                MyconponViewController *conpon = [MyconponViewController new];
                NavigationController *navi = (NavigationController *)[RootManager sharedManager].tabbarController.viewControllers[[RootManager sharedManager].tabbarController.selectedIndex];
                [navi pushViewController:conpon animated:YES];

            });
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [Utils postMessage:@"领取优惠券失败" onView:[UIApplication sharedApplication].keyWindow];
        }];
    }
}

@end
