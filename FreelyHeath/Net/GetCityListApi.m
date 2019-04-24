//
//  GetCityListApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/19.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetCityListApi.h"
#import "CityListModel.h"
@implementation GetCityListApi
- (void)sublistDetail:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *arr = [CityListModel mj_objectArrayWithKeyValuesArray:responseObject[@"citys"]];
    return arr;
}
@end
