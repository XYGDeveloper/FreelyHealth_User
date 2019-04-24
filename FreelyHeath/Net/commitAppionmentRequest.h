//
//  commitAppionmentRequest.h
//  FreelyHeath
//
//  Created by L on 2018/5/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface commitAppionmentHeader : NSObject
@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy)NSString *versioncode;
@property (nonatomic , copy)NSString *devicenum;
@property (nonatomic , copy)NSString *fromtype;
@property (nonatomic , copy)NSString *token;
@end

@interface commitAppionmentBody : NSObject
@property (nonatomic , copy)NSString *teamid;
@property (nonatomic , copy)NSString *recordid;
@property (nonatomic , copy)NSString *age;
@property (nonatomic , copy)NSString *member;
@property (nonatomic , copy)NSString *ismarry;
@property (nonatomic , copy)NSString *topic;
//teamid    string    是    团队id
//recordid    string    是    病历id
//member    string    是    成员Str
//topic    string    是    会诊主题
@end
@interface commitAppionmentRequest : NSObject
@property (nonatomic,strong)commitAppionmentHeader *head;
@property (nonatomic,strong)commitAppionmentBody *body;
@end
