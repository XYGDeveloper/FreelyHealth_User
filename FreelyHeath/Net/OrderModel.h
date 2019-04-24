//
//  OrderModel.h
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/13.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic , copy) NSString *planid;  //商品套餐id
@property (nonatomic , copy) NSString *cityid;  //商品城市id
@property (nonatomic , copy) NSString *patientname; //患者名字
@property (nonatomic , copy) NSString *patientsex;  //患者性别
@property (nonatomic , copy) NSString *patientage;  //患者年龄
@property (nonatomic , copy) NSString *patientphone; //患者电话
@property (nonatomic , copy) NSString *hopedid; //期望医生
@property (nonatomic , copy) NSString *patientidentity;//
@property (nonatomic , copy) NSString *patientaddress; //患者地址
@property (nonatomic , copy) NSString *taocanid; //
@property (nonatomic , copy) NSString *type;  // 1 订单  2 体检订单 3.会诊预约
@property (nonatomic , copy) NSString *zilist; //是否有子列表  0  没  1  有
@property (nonatomic , assign) int count; //下单数量
@property (nonatomic , assign) double sumprice;  //
@property (nonatomic , copy) NSString *price;  //
@property (nonatomic , copy) NSString *coupondetailid;  //所用优惠券id  会诊传
@property (nonatomic , copy) NSString *mdtyuyueid;  //体检套餐id
@property (nonatomic , copy) NSString *couponprice;  //优惠卷价格
//
@property (nonatomic , copy) NSString *fuwufei;  //优惠卷价格


@end
