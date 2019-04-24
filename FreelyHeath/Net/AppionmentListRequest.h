//
//  AppionmentListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AppionmentListHeader : NSObject
@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy)NSString *versioncode;
@property (nonatomic , copy)NSString *devicenum;
@property (nonatomic , copy)NSString *fromtype;
@property (nonatomic , copy)NSString *token;
@end

@interface AppionmentListBody : NSObject
//会诊详情专用
@property (nonatomic,copy)NSString *id; //ID type
//会诊列表专用
@property (nonatomic,copy)NSString *type;  //1 全部 2待审核 3待会诊 4 已完成

@end

@interface AppionmentListRequest : NSObject
@property (nonatomic,strong)AppionmentListHeader *head;
@property (nonatomic,strong)AppionmentListBody *body;
@end
