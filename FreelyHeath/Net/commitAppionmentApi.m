//
//  commitAppionmentApi.m
//  FreelyHeath
//
//  Created by L on 2018/5/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "commitAppionmentApi.h"

@implementation commitAppionmentApi
- (void)commitAppionment:(NSMutableDictionary *)appionment{
    [self startRequestWithParams:appionment];
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
