//
//  TJOrderDetailModel.h
//  FreelyHeath
//
//  Created by L on 2018/1/11.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJOrderDetailModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *patientname;
@property (nonatomic,copy)NSString *patientphone;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *payment;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *itemno;
@property (nonatomic,copy)NSString *patientsex;
@property (nonatomic,copy)NSString *orderno;
@property (nonatomic,copy)NSString *patientage;
@property (nonatomic,copy)NSString *cityname;
@property (nonatomic,copy)NSString *items;
@property (nonatomic,copy)NSString *des;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *zilist;
@property (nonatomic,copy)NSString *taocanid;
@property (nonatomic,copy)NSString *nojg;
@property (nonatomic,assign)double sumprice;
@property (nonatomic,assign)int count;
@property (nonatomic,copy)NSString *fuwufei;
@property (nonatomic,copy)NSString *couponprice;
@property (nonatomic,copy)NSString *hzname;
@property (nonatomic,copy)NSString *mdtyuyueid;

@end
