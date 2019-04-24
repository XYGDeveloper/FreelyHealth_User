//
//  EditBSApi.m
//  FreelyHeath
//
//  Created by L on 2018/3/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "EditBSApi.h"

@implementation EditBSApi
- (void)EditBS:(NSMutableDictionary *)list{
    [self startRequestWithParams:list];
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
