//
//  TeamQueryRequest.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface teamQuryHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface teamQuryBody : NSObject


@end


@interface TeamQueryRequest : NSObject

@property (nonatomic , strong) teamQuryHeader *head;

@property (nonatomic , strong) teamQuryBody *body;


@end
