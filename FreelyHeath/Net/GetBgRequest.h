//
//  GetBgRequest.h
//  FreelyHeath
//
//  Created by L on 2017/11/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetBgHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface GetBgBody : NSObject

@property (nonatomic , copy) NSString *type;

@end


@interface GetBgRequest : NSObject

@property (nonatomic , strong) GetBgHeader *head;

@property (nonatomic , strong) GetBgBody *body;


@end
