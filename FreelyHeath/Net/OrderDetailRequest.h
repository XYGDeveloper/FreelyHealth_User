//
//  OrderDetailRequest.h
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface OrderDetailBody : NSObject

//status	String 	否	不填 所有 1未支付 2进行中 3 已完成

@property (nonatomic,copy)NSString *id;



@end



@interface OrderDetailRequest : NSObject

@property (nonatomic,strong)OrderDetailHeader *head;

@property (nonatomic,strong)OrderDetailBody *body;


@end
