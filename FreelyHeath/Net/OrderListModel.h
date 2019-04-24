//
//  OrderListModel.h
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject


//name    string    是    服务名称
//patientname    string    是    服务对象
//patientphone    string    是    服务对象电话
//status    string    是    订单状态
//payment    string    是    订单金额
//id    string    是    订单ID
//type    string    是    订单类型   1 就医服务
//count    Int    是    套餐数量
//sumprice    string    是    总价
//fuwufei    string    是    是否计算服务费用 0 否 1  是

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *payment;

@property (nonatomic,assign)int status;

@property (nonatomic,copy)NSString *patientphone;

@property (nonatomic,copy)NSString *patientname;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *createtime;

@property (nonatomic,copy)NSString *count;

@property (nonatomic,assign)double sumprice;

@property (nonatomic,copy)NSString *fuwufei;
@property (nonatomic,copy)NSString *hzname;

@end
