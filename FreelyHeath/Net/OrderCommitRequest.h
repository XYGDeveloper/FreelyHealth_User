//
//  OrderCommitRequest.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderCommitHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface orderCommitBody : NSObject

@property (nonatomic , copy) NSString *planid;            // planid
@property (nonatomic , copy) NSString *cityid;            // 商品城市id
@property (nonatomic , copy) NSString *patientname;       // 患者名字
@property (nonatomic , copy) NSString *patientsex;        // 患者性别
@property (nonatomic , copy) NSString *patientage;        // 患者年龄
@property (nonatomic , copy) NSString *patientphone;      // 患者电话
@property (nonatomic , copy) NSString *hopedid;           // 期望医生
@property (nonatomic , copy) NSString *patientidentity;   //已删除
@property (nonatomic , copy) NSString *patientaddress;    // 患者地址
@property (nonatomic , copy) NSString *taocanid;          // 体检套餐id
@property (nonatomic , copy) NSString *type;              // 1 订单  2 体检订单
@property (nonatomic , copy) NSString *zilist;            // 是否有子列表  0  没  1  有
@property (nonatomic , assign) int count;                 // 下单数量
@property (nonatomic , copy) NSString *coupondetailid;    // 所用优惠券id  会诊传
@property (nonatomic , copy) NSString *mdtyuyueid;        // 会诊id   会诊传
@property (nonatomic , copy) NSString *sumprice;          // 总价
@property (nonatomic , copy) NSString *price;             // 不含优惠价格
@property (nonatomic , copy) NSString *couponprice;       // 优惠券价格

@end

@interface OrderCommitRequest : NSObject
@property (nonatomic ,strong) orderCommitHeader *head;
@property (nonatomic ,strong) orderCommitBody *body;
@end
