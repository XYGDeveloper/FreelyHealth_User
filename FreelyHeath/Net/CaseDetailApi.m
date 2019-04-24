//
//  CaseDetailApi.m
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseDetailApi.h"
#import "CaseDetailModel.h"
@implementation CaseDetailApi
- (void)detailCase:(NSMutableDictionary *)list{
    [self startRequestWithParams:list];
}
- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    CaseDetailModel *model = [CaseDetailModel mj_objectWithKeyValues:responseObject];
    return model;
}

@end
