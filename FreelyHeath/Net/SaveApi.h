//
//  SaveApi.h
//  FreelyHeath
//
//  Created by L on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

@interface SaveApi : BaseApi

- (void)saveToFile:(NSMutableDictionary *)detail;


@end
