//
//  CommitSubsApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/12.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CommitSubsApi.h"

@implementation CommitSubsApi

- (void)toCommit:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];
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
