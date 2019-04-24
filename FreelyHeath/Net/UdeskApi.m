//
//  UdeskApi.m
//  FreelyHeath
//
//  Created by L on 2017/10/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "UdeskApi.h"
#import "UModel.h"
@implementation UdeskApi

- (void)getudesk:(NSMutableDictionary *)acha
{
    
    [self startRequestWithParams:acha];

}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    
    UModel *model = [UModel mj_objectWithKeyValues:responseObject];
    return model;
    
}


@end
