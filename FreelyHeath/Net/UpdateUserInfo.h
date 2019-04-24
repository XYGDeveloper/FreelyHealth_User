//
//  UpdateUserInfo.h
//  FreelyHeath
//
//  Created by L on 2017/12/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface updateUserHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end

@interface updateUserBody : NSObject

@property (nonatomic , copy) NSString *age;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *sex;

@property (nonatomic , copy) NSString *company;

@property (nonatomic , copy) NSString *facepath;

@property (nonatomic , copy) NSString *type;

@end

@interface UpdateUserInfo : NSObject

@property (nonatomic,strong)updateUserHeader *head;

@property (nonatomic,strong)updateUserBody *body;

@end
