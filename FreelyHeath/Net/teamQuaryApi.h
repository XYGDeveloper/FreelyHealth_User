//
//  teamQuaryApi.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

@class AllTeamModel;

@interface teamQuaryApi : BaseApi


- (void)teamQuaryList:(NSMutableDictionary *)detail;

@end
