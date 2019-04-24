//
//  LoginRequestApi.h
//  FreelyHeath
//
//  Created by L on 2017/7/22.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginRequestHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@end

@interface LoginRequestBody : NSObject

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *captcha;


@end



@interface LoginRequestApi : NSObject

@property (nonatomic,strong)LoginRequestHeader *head;

@property (nonatomic,strong)LoginRequestBody *body;

@end
