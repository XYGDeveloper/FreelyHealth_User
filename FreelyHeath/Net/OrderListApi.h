//
//  OrderListApi.h
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

@class OrderListModel;

@interface OrderListApi : BaseApi


- (void)getOrderList:(NSMutableDictionary *)detail;


@end
