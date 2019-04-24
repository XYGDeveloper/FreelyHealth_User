//
//  getCancerListApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "getCancerListApi.h"
#import "CancerModel.h"
@implementation getCancerListApi

- (void)sublistDetail:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    return responseObject;
}

@end
