//
//  GetGroupRequest.h
//  FreelyHeath
//
//  Created by L on 2018/5/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface groupHeader : NSObject
@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy)NSString *versioncode;
@property (nonatomic , copy)NSString *devicenum;
@property (nonatomic , copy)NSString *fromtype;
@property (nonatomic , copy)NSString *token;
@end

@interface groupBody : NSObject
//获取消息列表
//读取消息
@property (nonatomic , copy)NSString *id;

@end
@interface GetGroupRequest : NSObject
@property (nonatomic,strong)groupHeader *head;
@property (nonatomic,strong)groupBody *body;
@end
