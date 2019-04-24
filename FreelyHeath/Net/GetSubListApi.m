//
//  GetSubListApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/11.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetSubListApi.h"
#import "SubModel.h"
@implementation GetSubListApi
- (void)sublist:(NSMutableDictionary *)price{
    
    [self startRequestWithParams:price];

}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *sublist = [SubModel mj_objectArrayWithKeyValuesArray:responseObject[@"yuyues"]];
    return sublist;
}
@end
