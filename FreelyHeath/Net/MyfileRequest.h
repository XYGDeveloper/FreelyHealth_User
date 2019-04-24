//
//  MyfileRequest.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface myfileHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface myfileBody : NSObject

//status	String 	否	不填 所有 1未支付 2进行中 3 已完成

@end

@interface MyfileRequest : NSObject

@property (nonatomic,strong)myfileHeader *head;

@property (nonatomic,strong)myfileBody *body;


@end
