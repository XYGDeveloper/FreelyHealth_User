//
//  AuswerDetailRequest.h
//  FreelyHeath
//
//  Created by L on 2017/7/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DetailRequestHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface DetailRequestBody : NSObject

@property (nonatomic,copy)NSString *id;

@end


@interface AuswerDetailRequest : NSObject

@property (nonatomic,strong)DetailRequestHeader *head;

@property (nonatomic,strong)DetailRequestBody *body;

@end
