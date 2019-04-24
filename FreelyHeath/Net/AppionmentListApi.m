//
//  AppionmentListApi.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentListApi.h"
#import "AppionmentListModel.h"
@implementation AppionmentListApi
- (void)getAppionmentList:(NSMutableDictionary *)list{
    [self startRequestWithParams:list];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}
- (id)reformData:(id)responseObject {
    NSArray *list = [AppionmentListModel mj_objectArrayWithKeyValuesArray:responseObject[@"huizhens"]];
    return list;
}
@end