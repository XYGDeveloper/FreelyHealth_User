//
//  AlipayApi.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"
@class AliModel;

@interface AlipayApi : BaseApi

- (void)getAliOrder:(NSMutableDictionary *)detail;


@end
