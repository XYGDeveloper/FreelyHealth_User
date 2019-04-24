//
//  QAHomeApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QAHomeApi.h"

@implementation QAHomeApi

- (void)getHomeListWithRequest:(NSMutableDictionary *)homeRequest
{

    NSLog(@"%@",homeRequest);
    
    [self startRequestWithParams:homeRequest];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    NSLog(@"====+++++++========%@",responseObject);
    
    return responseObject;
    
}

@end
