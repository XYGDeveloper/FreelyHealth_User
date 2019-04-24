//
//  CancelOrderRequest.h
//  FreelyHeath
//
//  Created by L on 2017/8/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cancelOrderHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface cancelOrderBody : NSObject

@property (nonatomic , copy) NSString *id;

@end


@interface CancelOrderRequest : NSObject

@property (nonatomic , strong) cancelOrderHeader *head;

@property (nonatomic , strong) cancelOrderBody *body;


@end
