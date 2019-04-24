//
//  GetCancerListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CancerHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface CancerBody : NSObject

@end

@interface GetCancerListRequest : NSObject

@property (nonatomic,strong)CancerHeader *head;
@property (nonatomic,strong)CancerBody *body;

@end
