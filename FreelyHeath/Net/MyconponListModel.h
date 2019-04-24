//
//  MyconponListModel.h
//  FreelyHeath
//
//  Created by L on 2018/5/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyconponListModel : NSObject
@property (nonatomic,copy)NSString *id; //优惠券id
@property (nonatomic,copy)NSString *couponid;//优惠券类型id
@property (nonatomic,copy)NSString *starttime; //生效时间
@property (nonatomic,copy)NSString *endtime;//失效时间
@property (nonatomic,copy)NSString *name;//优惠券名
@property (nonatomic,copy)NSString *status;//优惠券状态
@property (nonatomic,copy)NSString *quota;//限额
@property (nonatomic,copy)NSString *type;//优惠券类型  立减1   满减 2
@property (nonatomic,copy)NSString *denominat;//面额
@property (nonatomic,copy)NSString *ismax;//最大

@end
