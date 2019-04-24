//
//  CaseListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface caseListHeader : NSObject
@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy)NSString *versioncode;
@property (nonatomic , copy)NSString *devicenum;
@property (nonatomic , copy)NSString *fromtype;
@property (nonatomic , copy)NSString *token;

@end

@interface caseListBody : NSObject
//病例列表

//删除病例,病例详情
@property (nonatomic , copy)NSString *id;
//编辑病例第二步
@property (nonatomic , copy)NSString *zhengzhuang;
@property (nonatomic , copy)NSString *jiwang;
@property (nonatomic , copy)NSString *zhiliao;
//新增病例
@property (nonatomic , copy)NSString *name;
@property (nonatomic , copy)NSString *sex;
@property (nonatomic , copy)NSString *ismarry;
@property (nonatomic , copy)NSString *hun;
@property (nonatomic , copy)NSString *jiazu;
@property (nonatomic , copy)NSString *isoften;
@property (nonatomic , copy)NSString *age;
@property (nonatomic , copy)NSString *type;
//类型   1 有常用人修改；0 有常用人普通新增 ；2 有常用联系人因为重复只新增病历
//病程记录
@property (nonatomic , copy)NSString *yaowu;
@property (nonatomic , copy)NSString *ywimages;
@property (nonatomic , copy)NSString *blimages;
@end
@interface CaseListRequest : NSObject
@property (nonatomic,strong)caseListHeader *head;
@property (nonatomic,strong)caseListBody *body;
@end
