//
//  PatientsListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface patientsHeader : NSObject
@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy)NSString *versioncode;
@property (nonatomic , copy)NSString *devicenum;
@property (nonatomic , copy)NSString *fromtype;
@property (nonatomic , copy)NSString *token;
@end

@interface patientsBody : NSObject
//编辑常用患者，新增常用患者
@property (nonatomic , copy)NSString *name;
@property (nonatomic , copy)NSString *sex;
@property (nonatomic , copy)NSString *age;
@property (nonatomic , copy)NSString *id;
@property (nonatomic , copy)NSString *ismarry;
@property (nonatomic , copy)NSString *hun;
@property (nonatomic , copy)NSString *jiazu;

@end
@interface PatientsListRequest : NSObject
@property (nonatomic,strong)patientsHeader *head;
@property (nonatomic,strong)patientsBody *body;
@end
