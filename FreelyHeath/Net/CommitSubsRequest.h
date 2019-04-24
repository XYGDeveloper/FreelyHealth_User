//
//  CommitSubsRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/12.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CommitTJyuyueHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end
@interface CommitTJyuyueBody : NSObject

@property (nonatomic , copy) NSString *tjnum;
@property (nonatomic , copy) NSString *tjpwd;
@property (nonatomic , copy) NSString *taocanid;
@property (nonatomic , copy) NSString *jgdetailid;
@property (nonatomic , copy) NSString *tjtime;
@property (nonatomic , copy) NSString *id;

@property (nonatomic , copy) NSString *patientage;
@property (nonatomic , copy) NSString *patientphone;
@property (nonatomic , copy) NSString *patientsex;
@property (nonatomic , copy) NSString *patientname;
@property (nonatomic , copy) NSString *patientaddress;
@property (nonatomic , copy) NSString *patientidentity;

@end
@interface CommitSubsRequest : NSObject
@property (nonatomic,strong)CommitTJyuyueHeader *head;
@property (nonatomic,strong)CommitTJyuyueBody *body;
@end
