//
//  TJyuyueRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/12.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TJyuyueHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end
@interface TJyuyueBody : NSObject
//num    string    是    体检套餐卡号
//pwd    string    是    体检套餐密码
@property (nonatomic , copy) NSString *num;
@property (nonatomic , copy) NSString *pwd;


//
@property (nonatomic , copy) NSString *tjnum;

@property (nonatomic , copy) NSString *tjpwd;
@property (nonatomic , copy) NSString *taocanid;

@property (nonatomic , copy) NSString *jgdetailid;
@property (nonatomic , copy) NSString *tjtime;
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *status;

//tjnum    string    是    体检卡号
//tjpwd    string    是    体检二维码
//taocanid    string    是    套餐id
//jgdetailid        string    是    子机构id
//tjtime    string    是    体检时间
//id    string    是    体检订单id
//status    string    是    客服是否确认  0 未确认   1  已经确认
//
@end
@interface TJyuyueRequest : NSObject
@property (nonatomic,strong)TJyuyueHeader *head;
@property (nonatomic,strong)TJyuyueBody *body;
@end
