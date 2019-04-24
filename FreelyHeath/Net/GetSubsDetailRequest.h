//
//  GetSubsDetailRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/12.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SubDetailHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end
@interface SubDetailBody : NSObject
@property (nonatomic , copy) NSString *id;
@end
@interface GetSubsDetailRequest : NSObject
@property (nonatomic,strong)SubDetailHeader *head;
@property (nonatomic,strong)SubDetailBody *body;
@end
