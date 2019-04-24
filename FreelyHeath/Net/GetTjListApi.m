//
//  GetTjListApi.m
//  FreelyHeath
//
//  Created by L on 2017/12/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetTjListApi.h"
#import "TJListModel.h"
@implementation GetTjListApi


- (void)gettjList:(NSMutableDictionary *)detail
{
    [self startRequestWithParams:detail];

}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    
    NSArray *arr = [TJListModel mj_objectArrayWithKeyValuesArray:responseObject[@"tjs"]];
    
    return arr;
    
}


@end
