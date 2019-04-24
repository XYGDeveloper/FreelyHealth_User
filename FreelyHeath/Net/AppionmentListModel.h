//
//  AppionmentListModel.h
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//id    string    是    会诊id
//topic    string    是    会诊主题
//type    string    是    当前列表状态
//members    JSONArray    是    会诊时间
//
//members参数：
//
//字段    类型    必填    说明
//name    string    是    医生
//hname    string    是    医院
@interface MemberChildModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *hname;
@end

@interface AppionmentListModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *topic;
@property (nonatomic,copy)NSString *huizhentime;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *member;
@property (nonatomic,strong)NSArray *members;
@end
