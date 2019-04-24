//
//  PreFillPatientsApi.m
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PreFillPatientsApi.h"
#import "PatientModel.h"
@implementation PreFillPatientsApi
- (void)prefillPatientsList:(NSMutableDictionary *)list{
    [self startRequestWithParams:list];
}
- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}
- (id)reformData:(id)responseObject {
    PatientModel *patient = [PatientModel mj_objectWithKeyValues:responseObject];
    return patient;
}
@end
