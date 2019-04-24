//
//  deleteApi.m
//  FreelyHeath
//
//  Created by L on 2018/3/22.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "deleteApi.h"

@implementation deleteApi

- (void)deleteOrderWithId:(NSMutableDictionary *)detail{
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
