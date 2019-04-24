//
//  GetHistoryBgApi.m
//  FreelyHeath
//
//  Created by L on 2017/11/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetHistoryBgApi.h"
#import "HistoryModel.h"
@implementation GetHistoryBgApi

- (void)getHistoryBgList:(NSMutableDictionary *)detail
{
    [self startRequestWithParams:detail];
    
}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    NSArray *arr = [HistoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"tjbgs"]];
    
    return arr;
    
}


@end
