//
//  versionUpdateApi.m
//  FreelyHeath
//
//  Created by L on 2017/11/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "versionUpdateApi.h"

@implementation versionUpdateApi

- (void)versionUpdate:(NSMutableDictionary *)detail
{
    
    [self startRequestWithParams:detail];

    
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