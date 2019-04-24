//
//  GetListNewRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SubNewHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end
@interface SubNewBody : NSObject
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *zilist;
@property (nonatomic , copy) NSString *type;

@end
@interface GetListNewRequest : NSObject
@property (nonatomic,strong)SubNewHeader *head;
@property (nonatomic,strong)SubNewBody *body;
@end
