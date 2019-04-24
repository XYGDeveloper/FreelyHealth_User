//
//  PriceCounterRequest.h
//  FreelyHeath
//
//  Created by L on 2018/3/20.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface priceHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface priceBody : NSObject
@property (nonatomic , copy) NSString *id;      //套餐id
@property (nonatomic , assign) int count;       //数量
@property (nonatomic , copy) NSString *fuwufei; //是否遵循服务费规则 0不遵循   1 遵循
@property (nonatomic , copy) NSString *coupondetailid;//优惠券id


@end
@interface PriceCounterRequest : NSObject
@property (nonatomic,strong)priceHeader *head;
@property (nonatomic,strong)priceBody *body;
@end
