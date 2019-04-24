//
//  CreatWXOrderRequest.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXRequestHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface WXRequestBody : NSObject

@property (nonatomic,copy)NSString *orderid;
@property (nonatomic,copy)NSString *zilist;


@end

@interface CreatWXOrderRequest : NSObject

@property (nonatomic,strong)WXRequestHeader *head;

@property (nonatomic,strong)WXRequestBody *body;


@end
