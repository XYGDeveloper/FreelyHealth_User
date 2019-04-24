//
//  getAchaApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/22.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "getAchaApi.h"
#import "GetCaptchaRequestApi.h"
@implementation getAchaApi


- (void)getAchaCode:(NSMutableDictionary *)acha
{
    
    [self startRequestWithParams:acha];
    
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
