//
//  TJOrderDetailRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/11.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TJOrderDetailHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end
@interface TJOrderDetailBody : NSObject
@property (nonatomic , copy) NSString *id;

@end
@interface TJOrderDetailRequest : NSObject
@property (nonatomic,strong)TJOrderDetailHeader *head;
@property (nonatomic,strong)TJOrderDetailBody *body;
@end
