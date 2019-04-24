//
//  LoginApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/22.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi

- (void)loginWithRequest:(NSMutableDictionary *)loginRes
{

    [self startRequestWithParams:loginRes];

    
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
