//
//  AlipayApi.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AlipayApi.h"
#import "AliModel.h"
@implementation AlipayApi

- (void)getAliOrder:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    AliModel *model = [AliModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}


@end
