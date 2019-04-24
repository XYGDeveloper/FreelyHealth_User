//
//  GetBigItemApi.m
//  FreelyHeath
//
//  Created by L on 2018/2/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetBigItemApi.h"
#import "BigItemModel.h"
@implementation GetBigItemApi
- (void)sublistDetail:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *arr = [BigItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"tjs"]];
    return arr;
}
@end
