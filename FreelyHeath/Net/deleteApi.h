//
//  deleteApi.h
//  FreelyHeath
//
//  Created by L on 2018/3/22.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

@interface deleteApi : BaseApi
- (void)deleteOrderWithId:(NSMutableDictionary *)detail;

@end
