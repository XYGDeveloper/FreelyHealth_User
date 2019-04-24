//
//  GetTJPriceAndNameRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TJpriceHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end
@interface TJpriceBody : NSObject
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *zilist;
@end

@interface GetTJPriceAndNameRequest : NSObject
@property (nonatomic,strong)TJpriceHeader *head;
@property (nonatomic,strong)TJpriceBody *body;
@end
