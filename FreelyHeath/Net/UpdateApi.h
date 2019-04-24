//
//  UpdateApi.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/6.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

//版本检查
#define appid       @"1286632380"

#define UpdateAddress @"http://itunes.apple.com/cn/lookup?id="

@interface UpdateApi : BaseApi

- (void)getmyfile:(NSMutableDictionary *)detail;


@end
