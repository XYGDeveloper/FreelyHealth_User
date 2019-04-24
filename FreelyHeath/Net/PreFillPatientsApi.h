//
//  PreFillPatientsApi.h
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"

@interface PreFillPatientsApi : BaseApi
- (void)prefillPatientsList:(NSMutableDictionary *)list;

@end
