//
//  WorkOrderApi.h
//  FreelyHeath
//
//  Created by L on 2017/10/31.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

@interface WorkOrderApi : BaseApi

- (id)initWithOrderStatus:(NSString *)timestamp hotelid:(NSString *)sign;

//- (void)workorder:(NSMutableDictionary *)detail;

@end
