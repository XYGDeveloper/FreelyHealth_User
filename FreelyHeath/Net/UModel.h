//
//  UModel.h
//  FreelyHeath
//
//  Created by L on 2017/10/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UModel : NSObject

@property (nonatomic,copy)NSString *timestamp;

@property (nonatomic,copy)NSString *sign;

@property (nonatomic,copy)NSString *open_api_auth_token;
//timestamp    string    是    请求时间戳
//sign    string    是    签名
//open_api_auth_token    string    是    udesktoken

@end
