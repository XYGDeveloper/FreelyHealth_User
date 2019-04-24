//
//  CaseListApi.m
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseListApi.h"
#import "CaseListModel.h"
@implementation CaseListApi

- (void)getCaseList:(NSMutableDictionary *)list{
    [self startRequestWithParams:list];
}
- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}
- (id)reformData:(id)responseObject {
    NSArray *list = [CaseListModel mj_objectArrayWithKeyValuesArray:responseObject[@"bllist"]];
    return list;
}

@end
