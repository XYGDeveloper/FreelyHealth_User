//
//  ApiResponse.m
//
//  Created by xyg on 2017/3/18.
//  Copyright © 2017年 xyg. All rights reserved.
//

#import "ApiResponse.h"
#import "LoginViewController.h"
//#import "BaseNavigationController.h"
#import "AlertView.h"
#import "UIAlertView+Block.h"
#define kFetchTag1 200
#import "RootManager.h"
@interface ApiResponse ()<UIAlertViewDelegate>

/**
 *  api请求返回的状态码
 */
@property (nonatomic, copy, readwrite) NSString *code;

/**
 *  api请求返回的http状态码
 */
@property (nonatomic, assign, readwrite) NSInteger httpCode;

/**
 *  api请求返回的说明信息，如“请求成功”、“登陆失败等”
 */
@property (nonatomic, copy, readwrite) NSString *msg;

@end

@implementation ApiResponse

+ (instancetype)responseWithTask:(NSURLSessionTask *)task response:(id)responseObject error:(NSError *)error {
    ApiResponse *response = [[ApiResponse alloc] init];
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        response.code = responseObject[@"returncode"];
        response.msg = responseObject[@"msg"];
    }
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        response.httpCode = httpResponse.statusCode;
    }
    
    return response;
}

- (NSString *)msg {
    if (!_msg || _msg.length <= 0) {
        return NSLocalizedString(@"网络连接状态不正确", nil);
    }else if ([_msg isEqualToString:@"token失效"])
    {
        return @"token失效";
    }else{
        return _msg;
    }
}

@end
