//
//  OrderDetailModel.h
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface itemModel : NSObject

//"id": "1",
//"finish": "N",
//"name": "免费专家号源代预约",
//"no": 1
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *finish;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *no;

@end


@interface OrderDetailModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *patientname;
@property (nonatomic,copy)NSString *patientphone;
@property (nonatomic,assign)int status;
@property (nonatomic,copy)NSString *payment;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *itemno;
@property (nonatomic,copy)NSString *patientsex;
@property (nonatomic,copy)NSString *patientage;
@property (nonatomic,copy)NSString *cityname;
@property (nonatomic,copy)NSString *sumprice;

@property (nonatomic,strong)NSArray *items;

//"patientsex": "男",
//"cityname": "成都",
//"payment": 0.01,
//"id": "93200e449f1b400da67d77ed32462a9f",
//"patientname": "涨",
//"patientphone": "13544199592",
//"name": "陪诊服务",
//"patientage": 44

@end
