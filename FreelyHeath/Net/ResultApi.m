//
//  ResultApi.m
//  FreelyHeath
//
//  Created by L on 2017/8/9.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ResultApi.h"
#import "ResultModel.h"
@implementation ResultApi


- (void)getmyfile:(NSMutableDictionary *)detail
{
    
    [self startRequestWithParams:detail];
    
}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    
    ResultModel *model = [ResultModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
    
    
}



@end
