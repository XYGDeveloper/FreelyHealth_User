//
//  ToAuswerApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ToAuswerApi.h"

@implementation ToAuswerApi

- (void)toAuswerWithRequest:(NSMutableDictionary *)auswer
{

    [self startRequestWithParams:auswer];


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
