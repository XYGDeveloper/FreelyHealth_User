//
//  MyconponListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/5/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MyconponListHeader : NSObject
@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy)NSString *versioncode;
@property (nonatomic , copy)NSString *devicenum;
@property (nonatomic , copy)NSString *fromtype;
@property (nonatomic , copy)NSString *token;
@end

@interface MyconponListBody : NSObject
@property (nonatomic , copy)NSString *id;   // 是    当前订单 套餐id
@property (nonatomic , copy)NSString *type;   // 是    当前订单 套餐id
@property (nonatomic , copy)NSString *zilist;   // 是    当前订单 套餐id

@end
@interface MyconponListRequest : NSObject
@property (nonatomic,strong)MyconponListHeader *head;
@property (nonatomic,strong)MyconponListBody *body;

@end
