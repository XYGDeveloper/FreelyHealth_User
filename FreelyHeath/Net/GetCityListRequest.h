//
//  GetCityListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/19.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface cHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end
@interface cBody : NSObject
@property (nonatomic , copy) NSString *id;
@end
@interface GetCityListRequest : NSObject
@property (nonatomic,strong)cHeader *head;
@property (nonatomic,strong)cBody *body;
@end
