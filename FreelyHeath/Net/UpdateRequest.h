//
//  UpdateRequest.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageModel : NSObject

@property (nonatomic,  copy)NSString *imagepath;

@end

@interface updatemyfileHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface updatemyfileBody : NSObject

@property (nonatomic , copy) NSString *id;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *sex;

@property (nonatomic , copy) NSString *age;

@property (nonatomic , copy) NSString *city;

@property (nonatomic , copy) NSString *rname;

@property (nonatomic , copy) NSArray *images;


//status	String 	否	不填 所有 1未支付 2进行中 3 已完成

@end

@interface UpdateRequest : NSObject

@property (nonatomic,strong)updatemyfileHeader *head;

@property (nonatomic,strong)updatemyfileBody *body;

@end
