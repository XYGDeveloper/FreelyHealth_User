//
//  GetSubNewApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetSubNewApi.h"
#import "NewModel.h"
@implementation GetSubNewApi
- (void)sublistDetail:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *arr = [NewModel mj_objectArrayWithKeyValuesArray:responseObject[@"tjs"]];
    return arr;
}
@end
