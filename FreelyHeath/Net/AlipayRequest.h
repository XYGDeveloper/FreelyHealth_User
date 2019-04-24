//
//  AlipayRequest.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliRequestHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface AliRequestBody : NSObject

@property (nonatomic,copy)NSString *orderid;
@property (nonatomic,copy)NSString *zilist;

@end

@interface AlipayRequest : NSObject


@property (nonatomic,strong)AliRequestHeader *head;

@property (nonatomic,strong)AliRequestBody *body;

@end
