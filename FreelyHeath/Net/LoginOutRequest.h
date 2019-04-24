//
//  LoginOutRequest.h
//  FreelyHeath
//
//  Created by L on 2017/7/31.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginOutHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface LoginOutBody : NSObject


@end

@interface LoginOutRequest : NSObject

@property (nonatomic,strong)LoginOutHeader *head;

@property (nonatomic,strong)LoginOutBody *body;


@end
