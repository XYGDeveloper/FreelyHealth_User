//
//  WXCreatOrderApi.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WXCreatOrderApi.h"
#import "WXorderModel.h"
@implementation WXCreatOrderApi

- (void)getWXOrder:(NSMutableDictionary *)detail
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
