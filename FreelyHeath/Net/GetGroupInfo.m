//
//  GetGroupInfo.m
//  FreelyHeath
//
//  Created by L on 2018/5/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetGroupInfo.h"
#import "GroupModel.h"
@implementation GetGroupInfo
- (void)getGroup:(NSMutableDictionary *)appionment{
    [self startRequestWithParams:appionment];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}
- (id)reformData:(id)responseObject {
    GroupModel *model  = [GroupModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
