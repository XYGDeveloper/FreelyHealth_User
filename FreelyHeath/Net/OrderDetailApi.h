//
//  OrderDetailApi.h
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

@class OrderDetailModel;


@interface OrderDetailApi : BaseApi

- (void)getOrderdetail:(NSMutableDictionary *)detail;



@end
