//
//  GetSubsDetailApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/12.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetSubsDetailApi.h"
#import "SubDetailModel.h"
@implementation GetSubsDetailApi

- (void)sublistDetail:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    SubDetailModel *model = [SubDetailModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
