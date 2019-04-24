//
//  OrderConponListApi.m
//  FreelyHeath
//
//  Created by L on 2018/5/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderConponListApi.h"
#import "MyconponListModel.h"
@implementation OrderConponListApi
- (void)getorderConponList:(NSMutableDictionary *)list{
    [self startRequestWithParams:list];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}
- (id)reformData:(id)responseObject {
    NSArray *list = [MyconponListModel mj_objectArrayWithKeyValuesArray:responseObject[@"mycouponlist"]];
    return list;
}
@end
